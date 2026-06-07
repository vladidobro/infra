local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node

return {
  s('embed', {
    t('from IPython import embed; embed(colors="neutral")'),
  }),
}
