import csv
from typing import Final

SAVE_VAR: Final[str] = "EF.vars.minigames.parlor.puzzle_list"

PRE_TABLE_LINES: Final[str] = """EF.vars.minigames.parlor.boxes = {"Blue", "White", "Black"}
EF.vars.minigames.parlor.box_colors = {G.C.BLUE, G.C.WHITE, G.C.BLACK}
"""

CSV_PATH: str = input("csv path: ")
SAVE_PATH: Final[str] = "src/ui/parlor/puzzle_list.lua"

#CSV format: blue_box, white_box, black_box, solution_index
with open(CSV_PATH, 'r') as csv_file:
    reader = csv.reader(csv_file)
    with open("output.lua", "w") as out_file:
        out_file.write(PRE_TABLE_LINES)
        out_file.write(SAVE_VAR + " = {\n")
        for row in reader:
            out_file.write("   {%s, %s, %s, %s},\n" % (repr(row[0]), repr(row[1]), repr(row[2]), row[3]))
        out_file.write("}")