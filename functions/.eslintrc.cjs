const js = require('@eslint/js');

module.exports = [
  js.configs.recommended,
  {
    rules: {
      quotes: ['error', 'double'],
      indent: ['error', 2],
      'object-curly-spacing': ['error', 'never'],
      'comma-dangle': ['error', 'never'],
      'max-len': ['error', {code: 100}],
    }
  }
];
