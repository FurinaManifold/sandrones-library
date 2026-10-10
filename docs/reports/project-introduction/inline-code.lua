-- Allow long ASCII declaration names and paths to wrap inside paragraphs/tables.
function Code(el)
  if FORMAT ~= 'latex' or #el.text < 21 or el.text:find('[\128-\255]') then
    return nil
  end
  local escapes = {
    ['\\'] = '\\textbackslash{}', ['{'] = '\\{', ['}'] = '\\}',
    ['%'] = '\\%', ['$'] = '\\$', ['#'] = '\\#', ['&'] = '\\&',
    ['_'] = '\\_', ['~'] = '\\textasciitilde{}', ['^'] = '\\textasciicircum{}'
  }
  local text = el.text:gsub('[\\{}%%$#&_~^]', function(c) return escapes[c] end)
  return pandoc.RawInline('latex', '\\texttt{\\seqsplit{' .. text .. '}}')
end
