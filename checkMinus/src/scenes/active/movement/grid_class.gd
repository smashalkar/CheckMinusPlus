extends Node2D

enum CELL_TYPES{VOID = -1, EMPTY, OBSTACLE, ACTIVE, ITEM, OBJECT, END}
export(CELL_TYPES) var type = CELL_TYPES.ACTIVE

enum PLAYER_TYPES{MAIN, WILD, EVIL, OTHER}
