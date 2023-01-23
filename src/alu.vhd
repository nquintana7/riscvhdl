library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity riscv_alu is
    port (
        srcA: in std_logic_vector(31 downto 0);
        srcB: in std_logic_vector(31 downto 0);
        op: in std_logic_vector(2 downto 0);
        result: out std_logic_vector(31 downto 0);
        zero : out std_logic
    );
end riscv_alu;

architecture behavorial of riscv_alu is
    constant zeros : std_logic_vector(31 downto 0) := (others => '0');
    signal tmpresult : std_logic_vector(31 downto 0);
    signal tmpcomp : std_logic;
begin
    tmpcomp <= '1' when srcA < srcB else
               '0';
    tmpresult <=  srcA + srcB when op = "000" else
                  srcA - srcB  when op = "001" else
                  srcA and srcB when op = "010" else
                  srcA or srcB when op = "011" else
                  (31 downto 1 => '0') & tmpcomp;
    result <= tmpresult;
    zero <= '1' when tmpresult = zeros else
            '0';
end behavorial;