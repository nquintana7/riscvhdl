library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_extend is
    port (inst: in std_logic_vector(31 downto 7);
          src : in std_logic_vector(1 downto 0);
          ex_imm: out std_logic_vector(31 downto 0));
end riscv_extend;

architecture behavorial of riscv_extend is
begin
    ex_imm <= (31 downto 12 => inst(31)) & inst(31 downto 20) when src = "00" else
              (31 downto 12 => inst(31)) & inst(31 downto 25) & inst(11 downto 7) when src = "01" else
              (31 downto 12 => inst(31)) & inst(7) & inst(30 downto 25) & inst(11 downto 8) & '0' when src = "10" else
              (31 downto 20 => inst(31)) & inst(19 downto 12) & inst(20) & inst(30 downto 21) & '0';
end behavorial;