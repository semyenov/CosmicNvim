from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title

# from kitty.rgb import Color
# from kitty.utils import color_as_int

def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
    screen.draw("test")
    tab.title = "test1"
    draw_title(draw_data, screen, tab, 5)
    end = screen.cursor.x
    return end
