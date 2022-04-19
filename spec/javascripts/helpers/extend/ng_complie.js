function ngTemplateCompile($compile, $scope, template) {
  var el = $compile(template)($scope);
  $scope.$digest();
  return el;
}

function ngTemplateCompiler($compile, $scope) {
  return function (template) {
    return ngTemplateCompile($compile, $scope, template);
  }
}
