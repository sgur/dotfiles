vim9script

# https://github.com/reinderien/mimic


# Internal {{{1

export def Highlight()
  var patterns = [
        \ ['problematic_space_id', '\%(\s\+$\| \+\t\|　\)', 'ProblematicSpaces'],
        \ ['homoglyph_match_id', regex, 'Homoglyphs']]
  var is_blacklisted = IsBlacklisted()
  for [id, pattern, hlgroup] in patterns
    if exists('w:' .. id) && is_blacklisted
      silent! matchdelete(eval('w:' .. id))
      execute 'unlet!' 'w:' .. id
    endif
    if !exists('w:' .. id) && !is_blacklisted
      setwinvar(bufwinnr(bufnr()), id, matchadd(hlgroup, pattern))
    endif
  endfor
enddef


# Interface {{{1

def FlattenValues(dict: dict<list<any>>): list<string>
  var new_list = []
  map(values(dict), (k, v) => extend(new_list, v))
  return new_list
enddef

def IsBlacklisted(): bool
  return index(get(g:, 'mimic_filetype_blacklists', []), &filetype) > -1 || empty(&filetype)
        \ || &l:diff || !empty(&l:buftype) || !&l:modifiable || &l:readonly || &l:previewwindow
enddef

def InitializeHighlight()
  highlight link ProblematicSpaces SpellRare
  highlight link Homoglyphs SpellLocal
enddef


# Initialization {{{1

g:mimic_killer_filetype_blacklists = get(g:, 'mimic_killer_filetype_blacklists', ['text', 'gitcommit', 'diff'])

var homoglyphs = {
  " ": ["\u2000", "\u2001", "\u2002", "\u2003", "\u2004", "\u2005", "\u2006", "\u2008", "\u2009", "\u200A", "\u202F", "\u205F", "\u00A0", "\u2007"],
  "!": ["\uFE15", "\uFE57", "\u2D51", "\uFF01", "\u01C3"],
  '"': ["\uFF02"],
  "#": ["\uFE5F", "\uFF03"],
  "$": ["\uFE69", "\uFF04"],
  "%": ["\u2052", "\uFE6A", "\u066A", "\uFF05"],
  "&": ["\uFE60", "\uFF06"],
  "'": ["\u02B9", "\u0374", "\uFF07"],
  "(": ["\uFE59", "\uFF08"],
  ")": ["\uFE5A", "\uFF09"],
  "*": ["\u22C6", "\uFE61", "\uFF0A"],
  "+": ["\uFE62", "\uFF0B", "\u16ED"],
  ",": ["\u02CF", "\u201A", "\uFF0C", "\u16E7"],
  "-": ["\u02D7", "\u2574", "\uFE63", "\uFF0D", "\u23BC", "\u2212"],
  ".": ["\u2024", "\uFF0E"],
  "/": ["\u29F8", "\u2044", "\uFF0F", "\u2215", "\u1735"],
  "2": ["\u14BF"],
  "3": ["\u2128", "\u01B7"],
  "4": ["\u13CE"],
  "6": ["\u13EE"],
  "9": ["\u13ED"],
  ":": ["\u02D0", "\uFE13", "\u02F8", "\u0589", "\u205A", "\uFE55", "\u2806", "\u1361", "\uFF1A", "\u16EC", "\u2236"],
  ";": ["\uFE14", "\uFE54", "\u037E", "\uFF1B"],
  "<": ["\u276E", "\u227A", "\u02C2", "\u2039", "\u2D66", "\uFF1C", "\uFE64"],
  "=": ["\u2550", "\uFE66", "\u268C", "\uFF1D"],
  ">": ["\u276F", "\u203A", "\uFE65", "\u227B", "\uFF1E", "\u02C3"],
  "?": ["\uFE16", "\uFF1F", "\uFE56"],
  "@": ["\uFE6B", "\uFF20"],
  "A": ["\u0391", "\u13AA", "\u0410"],
  "B": ["\u2C82", "\u0392", "\u15F7", "\u0412", "\u13F4"],
  "C": ["\u2CA4", "\u03F9", "\u0421", "\u216D", "\u13DF"],
  "D": ["\u15EA", "\u13A0", "\u216E"],
  "E": ["\u0395", "\u13AC", "\u0415"],
  "F": ["\u15B4"],
  "G": ["\u050C", "\u13C0"],
  "H": ["\u2C8E", "\u0397", "\u13BB", "\u041D", "\u12D8", "\u157C"],
  "I": ["\u0399", "\u0406", "\u2160"],
  "J": ["\u13AB", "\u0408", "\u148D"],
  "K": ["\u2C94", "\u039A", "\u212A", "\u13E6", "\u16D5"],
  "L": ["\u216C", "\u13DE", "\u14AA"],
  "M": ["\u039C", "\u03FA", "\u13B7", "\u041C", "\u216F"],
  "N": ["\u2C9A", "\u039D"],
  "O": ["\u2C9E", "\u039F", "\u041E"],
  "P": ["\u2CA2", "\u03A1", "\u0420", "\u13E2"],
  "Q": ["\u051A", "\u2D55"],
  "R": ["\u1587", "\u13A1", "\u13D2"],
  "S": ["\u0405", "\u13DA"],
  "T": ["\u03A4", "\u13A2", "\u0422"],
  "V": ["\u2164", "\u13D9"],
  "W": ["\u13D4", "\u13B3"],
  "X": ["\u2CAC", "\u03A7", "\u2169", "\u0425"],
  "Y": ["\u2CA8", "\u03A5"],
  "Z": ["\u0396", "\u13C3"],
  "[": ["\uFF3B"],
  '\': ["\u29F5", "\u29F9", "\uFE68", "\uFF3C", "\u2216"],
  "]": ["\uFF3D"],
  "^": ["\u02C6", "\u2303", "\u1DBA", "\uFF3E", "\u02C4"],
  "_": ["\u02CD", "\uFF3F", "\u268A"],
  "`": ["\u02CB", "\u2035", "\u1FEF", "\uFF40"],
  "a": ["\u0430", "\u0251"],
  "c": ["\u03F2", "\u217D", "\u0441"],
  "d": ["\u0501", "\u217E"],
  "e": ["\u0435", "\u1971"],
  "g": ["\u0261"],
  "h": ["\u04BB"],
  "i": ["\u2170", "\u0456"],
  "j": ["\u03F3", "\u0458"],
  "l": ["\u217C"],
  "m": ["\u217F"],
  "n": ["\u1952"],
  "o": ["\u0D20", "\u03BF", "\u2C9F", "\u043E"],
  "p": ["\u2CA3", "\u0440"],
  "s": ["\u0455"],
  "u": ["\u1959", "\u222A"],
  "v": ["\u22C1", "\u1D20", "\u2174", "\u2228"],
  "w": ["\u1D21"],
  "x": ["\u2CAD", "\u2179", "\u0445"],
  "y": ["\u1EFF", "\u0443"],
  "z": ["\u1D22"],
  "{": ["\uFE5B", "\uFF5B"],
  "|": ["\u23AE", "\u239C", "\u239F", "\u23A2", "\u23A5", "\u23AA", "\uFF5C", "\u01C0", "\u16C1", "\uFFE8"],
  "}": ["\uFF5D", "\uFE5C"],
  "~": ["\uFF5E", "\u02DC", "\u2053", "\u223C"]
}

var regex = '\%(' .. join(FlattenValues(homoglyphs), '\|') .. '\)'


augroup plugin_mimic_highlight
  autocmd!
  autocmd VimEnter,ColorScheme *  InitializeHighlight()
augroup END
InitializeHighlight()


# 1}}}
