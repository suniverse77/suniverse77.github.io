---
layout: compress
# WARNING: Don't use '//' to comment out code, use '{% comment %}' and '{% endcomment %}' instead.
---

{%- comment -%}
  See: <https://docs.mathjax.org/en/latest/options/input/tex.html#tex-options>

  Bold shorthand macros: \v + a letter or a Greek letter name.
    \vx -> \mathbf{x}, \vA -> \mathbf{A}
    \vlambda -> \boldsymbol{\lambda}, \vSigma -> \boldsymbol{\Sigma}
  The same list is registered for the VS Code preview in .vscode/settings.json.
{%- endcomment -%}

const boldMacros = {};

'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').forEach((letter) => {
  boldMacros['v' + letter] = '\\mathbf{' + letter + '}';
});

[
  'alpha', 'beta', 'gamma', 'delta', 'epsilon', 'varepsilon', 'zeta', 'eta',
  'theta', 'vartheta', 'iota', 'kappa', 'lambda', 'mu', 'nu', 'xi', 'pi', 'varpi',
  'rho', 'varrho', 'sigma', 'varsigma', 'tau', 'upsilon', 'phi', 'varphi', 'chi',
  'psi', 'omega', 'Gamma', 'Delta', 'Theta', 'Lambda', 'Xi', 'Pi', 'Sigma',
  'Upsilon', 'Phi', 'Psi', 'Omega'
].forEach((name) => {
  boldMacros['v' + name] = '\\boldsymbol{\\' + name + '}';
});

MathJax = {
  tex: {
    {%- comment -%} start/end delimiter pairs for in-line math {%- endcomment -%}
    inlineMath: [
      ['$', '$'],
      ['\\(', '\\)']
    ],
    {%- comment -%} start/end delimiter pairs for display math {%- endcomment -%}
    displayMath: [
      ['$$', '$$'],
      ['\\[', '\\]']
    ],
    {%- comment -%} equation numbering {%- endcomment -%}
    tags: 'ams',
    macros: boldMacros
  }
};
