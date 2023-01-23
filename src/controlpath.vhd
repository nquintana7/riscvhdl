library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_control is
    port (op: in std_logic_vector(6 downto 0);
          funct3 : in std_logic_vector(14 downto 12);
          funct7: in std_logic;
          zero : in std_logic;
          pcsrc: out std_logic;
        resultsrc: out std_logic_vector(1 downto 0);
        memwrite: out std_logic;
        aluctrl : out std_logic_vector(2 downto 0);
        alusrc : out std_logic;
        immsrc : out std_logic_vector(1 downto 0);
        regwrite : out std_logic;
        jump : out std_logic);
end riscv_control;

architecture behavorial of riscv_control is
    signal branch : std_logic;
    signal aluop : std_logic_vector(1 downto 0);
    signal rtype_sub : std_logic;
    signal output_tmp : std_logic_vector(10 downto 0);
    signal tmpjump : std_logic;
begin
    rtype_sub <= op(5) and funct7;
    -- Main Decoder
    process(op)
    begin
        case (op) is
            when "0000011" => output_tmp <= "10010010000"; 
            when "0100011" => output_tmp <= "00111000000"; 
            when "0110011" => output_tmp <=  "10000000100";
            when "1100011" => output_tmp <= "01000001010"; 
            when "0010011"  => output_tmp <= "10010000100"; 
            when "1101111" => output_tmp <= "11100100001";
            when others => output_tmp <= "10000000100";
        end case;
    end process;
    (regwrite, immsrc(1), immsrc(0), alusrc, memwrite, resultsrc(1), resultsrc(0), branch, aluop(1), aluop(0), tmpjump) <= output_tmp;
    -- ALU Decoder
    aluctrl <= "000" when aluop = "00" else
               "001" when aluop = "01" else
               "000" when funct3 = "000" and rtype_sub = '0' else
               "001" when funct3 = "000" else
               "101" when funct3 = "010" else
               "011" when funct3 = "110" else
               "010";
    jump <= tmpjump;
    pcsrc <= (branch and zero) or tmpjump;
end behavorial;