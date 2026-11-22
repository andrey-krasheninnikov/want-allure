import postcss from 'postcss';

/** Confine element selectors to each provider and retain the compiled cascade order. */
export function scopedCss(css: string): string {
  const root = postcss.parse(css);
  const output = postcss.root();
  root.walkAtRules(/^(property|keyframes|-webkit-keyframes|font-face)$/, rule => { output.append(rule); });
  root.walkRules(rule => {
    rule.selector = rule.selector.replaceAll('[data-allure-scope]', ':scope').replace(/:root\b|:host\b/g, ':scope')
      .replace(/(^|,\s*)(?:html|body)\b/g, '$1:scope');
  });
  let group: postcss.AtRule | undefined;
  for (const node of [...root.nodes]) {
    if (node.type === 'atrule' && node.name === 'scope' && node.params.startsWith('([data-allure-scope]')) {
      output.append(node);
      group = undefined;
    } else {
      if (!group) {
        group = postcss.atRule({ name: 'scope', params: '([data-allure-scope]) to ([data-allure-scope])' });
        output.append(group);
      }
      group.append(node);
    }
  }
  return output.toString();
}
