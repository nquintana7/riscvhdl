library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Ram will be expanded to interface the DDR3 RAM on board.

entity riscv_datamem is
    port (
        clk : in std_logic;
        we: in std_logic;
        a, wd: in std_logic_vector(31 downto 0);
        rd: out std_logic_vector(31 downto 0)
    );
end riscv_datamem;

architecture behavorial of riscv_datamem is
    type memory is array(63 downto 0) of std_logic_vector(31 downto 0);
    signal ram : memory;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                ram(to_integer(unsigned(a(7 downto 2)))) <= wd;
            end if;
        end if;
        rd <= ram(to_integer(unsigned(a(7 downto 2))));
    end process;
end behavorial;