library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Ports 1 and 2 are read ports, Port 3 is a write port
-- Read is asynchron, Write is syncron
entity riscv_regs is
    port (
        clk : in std_logic;
        we: in std_logic;
        a1, a2, a3: in std_logic_vector(4 downto 0);
        d3: in std_logic_vector(31 downto 0);
        r1, r2: out std_logic_vector(31 downto 0)
    );
end riscv_regs;

architecture behavorial of riscv_regs is
    type memory is array(31 downto 0) of std_logic_vector(31 downto 0);
    signal regs : memory;
    constant zeros : std_logic_vector(4 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                regs(to_integer(unsigned(a3))) <= d3;
            end if;
        end if;

    end process;

    r1 <= regs(to_integer(unsigned(a1))) when a1 /= zeros else
          (others => '0');
    r2 <= regs(to_integer(unsigned(a2))) when a2 /= zeros else
          (others => '0');
end behavorial;