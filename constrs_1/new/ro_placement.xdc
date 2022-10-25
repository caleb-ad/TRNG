create_pblock RO_0
add_cells_to_pblock [get_pblocks RO_0] [get_cells -quiet [list {genblk1[0].nolabel_line18/ro1}]]
resize_pblock [get_pblocks RO_0] -add {SLICE_X4Y49:SLICE_X7Y49}
set_property IS_SOFT FALSE [get_pblocks RO_0]
create_pblock RO_1
add_cells_to_pblock [get_pblocks RO_1] [get_cells -quiet [list {genblk1[0].nolabel_line18/ro2}]]
resize_pblock [get_pblocks RO_1] -add {SLICE_X4Y48:SLICE_X7Y48}
set_property IS_SOFT FALSE [get_pblocks RO_1]

create_pblock RO_2
add_cells_to_pblock [get_pblocks RO_2] [get_cells -quiet [list {genblk1[1].nolabel_line18/ro1}]]
resize_pblock [get_pblocks RO_2] -add {SLICE_X4Y47:SLICE_X7Y47}
set_property IS_SOFT FALSE [get_pblocks RO_2]
create_pblock RO_3
add_cells_to_pblock [get_pblocks RO_3] [get_cells -quiet [list {genblk1[1].nolabel_line18/ro2}]]
resize_pblock [get_pblocks RO_3] -add {SLICE_X4Y46:SLICE_X7Y46}
set_property IS_SOFT FALSE [get_pblocks RO_3]