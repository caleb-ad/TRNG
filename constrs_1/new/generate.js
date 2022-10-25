
function createTrngModule(i) {
    return`
create_pblock RO_${i * 2}
add_cells_to_pblock [get_pblocks RO_${i * 2}] [get_cells -quiet [list {genblk1[${i}].nolabel_line18/ro1}]]
resize_pblock [get_pblocks RO_${i * 2}] -add {SLICE_X4Y${49 - (i * 2)}:SLICE_X7Y${49 - (i * 2)}}
set_property IS_SOFT FALSE [get_pblocks RO_${i * 2}]
create_pblock RO_${(i * 2)+1}
add_cells_to_pblock [get_pblocks RO_${(i * 2)+1}] [get_cells -quiet [list {genblk1[${i}].nolabel_line18/ro2}]]
resize_pblock [get_pblocks RO_${(i * 2)+1}] -add {SLICE_X4Y${48 - (i * 2)}:SLICE_X7Y${48 - (i * 2)}}
set_property IS_SOFT FALSE [get_pblocks RO_${(i * 2)+1}]
`
}

for(let i = 0; i < 16; i++) {
    console.log(createTrngModule(i))
}