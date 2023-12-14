local utils = require('utils')

local yamlau = {
    {'filetype', 'yaml', 'setlocal', 'tabstop=2'},
    {'filetype', 'yaml', 'setlocal', 'softtabstop=2'},
    {'filetype', 'yaml', 'setlocal', 'shiftwidth=2'},
    {'BufNewFile,BufRead', '*.bu', 'setfiletype yaml'},
}

local texau = {
   {'filetype', 'tex', 'setlocal', 'makeprg=pdflatex\\ %'}
}

utils.create_augroup(yamlau, 'yaml')
utils.create_augroup(texau, 'tex')
