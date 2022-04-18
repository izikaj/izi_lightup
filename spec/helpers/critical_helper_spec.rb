# frozen_string_literal: true

RSpec.describe ::CriticalHelper, type: :helper do
  include RSpecHtmlMatchers
  let!(:request_defaults) do
    allow(helper).to receive(:controller_path).and_return 'welcome'
    allow(helper).to receive(:controller_name).and_return 'welcome'
    allow(helper).to receive(:action_name).and_return 'index'
  end

  # used to preload some css and switch it on if loaded successfully
  context '#css_preload' do
    it 'should render nothing if nothing passed' do
      expect(helper.css_preload([])).to be_blank
    end

    it 'should render rel=preload tag' do
      rendered = helper.css_preload('application')
      expect(rendered).to have_tag('link', with: { rel: :preload })
    end

    it 'should render rel=stylesheet tag inside noscript block' do
      rendered = helper.css_preload('application')
      expect(rendered).to have_tag('noscript') do
        with_tag('link', with: { rel: :stylesheet })
        without_tag('link', with: { rel: :preload })
      end
    end

    it 'should render many stylesheets inside one block' do
      rendered = helper.css_preload(%w[application critical vendor])
      expect(rendered).to have_tag('link', with: { rel: :preload }, count: 3)
      expect(rendered).to have_tag('noscript') do
        with_tag('link', with: { rel: :stylesheet }, count: 3)
        without_tag('link', with: { rel: :preload })
      end
    end
  end

  # used to render JS inline
  context '#inline_js' do
    it 'should work' do
      expect(helper.inline_js('application')).to be_present
    end

    it 'should render file content' do
      expect(helper.inline_js('application')).to include 'APPLICATION_JS'
    end
  end

  # used to render CSS inline
  context '#inline_css' do
    it 'should work' do
      expect(helper.inline_css('application')).to be_present
    end

    it 'should render file content' do
      expect(helper.inline_css('application')).to include 'APPLICATION_CSS'
    end
  end

  # used to render some request-specific critical css with fallbacks
  context '#critical_css' do
    context 'default request' do
      it 'should work' do
        expect(helper.critical_css).to be_present
      end

      it 'should not render warning' do
        expect(helper.critical_css).not_to include('CRIT CSS NOT FOUND')
      end

      it 'should find welcome#index critical CSS' do
        expect(helper.critical_css).to include('WELCOME_INDEX_CRITICAL_CSS')
      end
    end

    context 'param: scope' do
      it 'should customize scope for search critical CSS' do
        results = helper.critical_css(scope: 'custom')
        expect(results).to be_present
        expect(results).to include('CRIT CSS NOT FOUND')
        expect(results).not_to include('WELCOME_INDEX_CRITICAL_CSS')
      end
    end

    context 'param: stylesheets' do
      it 'should inject critical CSS & preload provided external stylesheets' do
        results = helper.critical_css(stylesheets: 'application')

        expect(results).to be_present
        expect(results).not_to include('CRIT CSS NOT FOUND')
        expect(results).to include('WELCOME_INDEX_CRITICAL_CSS')
        expect(results).to include('application.css')
      end
    end

    context 'real time assets compilation assets' do
      before(:all) do
        clean_all_assets!
        Rails.application.config.assets.compile = true
      end

      it 'should work' do
        expect(helper.critical_css).to be_present
      end

      it 'should find css file content' do
        expect(helper.critical_css).to include('WELCOME_INDEX_CRITICAL_CSS')
      end

      it 'should find not precompiled CSS' do
        allow(helper).to receive(:action_name).and_return('other')

        # check file is not precompiled
        expect(Rails.application.config.assets.precompile.detect { |p| p == 'critical/welcome_other.css' }).to be_nil

        expect(helper.critical_css).to include('WELCOME_OTHER_CRITICAL_CSS')
      end
    end

    context 'precompiled assets' do
      before(:all) do
        Rails.application.config.assets.compile = true
        clean_all_assets!
        compile_all_assets!
        Rails.application.config.assets.compile = false
      end

      it 'should work' do
        expect(helper.critical_css).to be_present
      end

      it 'should find css file content' do
        expect(helper.critical_css).to include 'WELCOME_INDEX_CRITICAL_CSS'
      end

      it 'should NOT find not precompiled CSS' do
        allow(helper).to receive(:action_name).and_return 'other'

        # check file is not precompiled
        expect(Rails.application.config.assets.precompile.detect { |p| p == 'critical/welcome_other.css' }).to be_nil

        expect(helper.critical_css).to include 'WELCOME_CRITICAL_CSS'
      end
    end
  end

  context '#names_for_critical_lookup' do
    it 'should return expected crit-css names for lookup' do
      results = helper.names_for_critical_lookup

      expect(results).to include 'critical/welcome_index.css'
      expect(results).to include 'critical/welcome.css'
      expect(results).to include 'critical.css'
    end

    it 'should allow to override default lookup scope' do
      results = helper.names_for_critical_lookup('mobile/critical')

      expect(results).to include 'mobile/critical.css'
      expect(results).not_to include 'critical/welcome_index.css'
      expect(results).not_to include 'critical.css'
    end

    it 'should allow to override default lookup extname' do
      results = helper.names_for_critical_lookup('critical', '.js')

      expect(results).to include 'critical/welcome_index.js'
      expect(results).to include 'critical/welcome.js'
      expect(results).to include 'critical.js'
    end

    context 'for namespaced requests' do
      let!(:request_defaults) do
        allow(helper).to receive(:controller_path).and_return 'some/useless/namespaced/dashboard'
        allow(helper).to receive(:controller_name).and_return 'dashboard'
        allow(helper).to receive(:action_name).and_return 'index'
      end

      let(:results) { helper.names_for_critical_lookup }

      it 'should include file for each namespace level' do
        expect(results).to include 'critical/some/useless/namespaced/dashboard.css'
        expect(results).to include 'critical/some/useless/namespaced.css'
        expect(results).to include 'critical/some/useless.css'
        expect(results).to include 'critical/some.css'
      end

      it 'should include scoped names & controller specific names' do
        expect(results).to include 'critical/some/useless/namespaced/dashboard_index.css'
        expect(results).to include 'critical/dashboard_index.css'
      end

      it 'more specific pathes has more priority' do
        expect(results.index('critical/some/useless/namespaced/dashboard_index.css')).to be < results.index('critical/dashboard_index.css')
      end
    end
  end

  # used to render some common JS-helpers to help with defferring
  # and lazy loading some js/css
  context '#critical_js' do
    context 'default request' do
      it 'should work' do
        expect(helper.critical_js).to be_present
      end

      it 'bundle should be overrideable' do
        results = helper.critical_js(bundle: 'application.js')

        expect(results).to be_present
        expect(results).to include('APPLICATION_JS')
      end
    end
  end
end
