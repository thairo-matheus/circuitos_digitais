library ieee;
use ieee.std_logic_1164.all;

entity sistema_transito is
		port(clock_st,Pi_st,Pf_st : in std_logic;
			  controlador : in std_logic_vector(1 downto 0);
			  Ms_st, Mn_st : out std_logic;
			  ledA, ledG : out std_logic_vector(2 downto 0));
end sistema_transito;

architecture rtl of sistema_transito is
	component sinal_radar is
		port(clock,Pi,Pf : in std_logic;
			  tempoVerdeAcai : integer range 20 to 30;
			  tempoVerdeGuarana : integer range 10 to 20;
			  tempoAmarelo : integer range 0 to 3;
			  Ms, Mn : out std_logic;
			  ledAcai, ledGuarana : out std_logic_vector(2 downto 0));
	end component;	
	
	signal	  tVA : integer range 20 to 30;
	signal	  tVG : integer range 10 to 20;
	signal	  tA  : integer range 0 to 3;
	--signal	  Ms_st, Mn_st : std_logic;
	signal 	  ledAcai, ledGuarana,config_C : std_logic_vector(2 downto 0);
	signal		cont: integer range 0 to 100000000;
	
	begin
	s_r: sinal_radar port map(clock_st,Pi_st,Pf_st,tVA,tVG,tA,Ms_st,Mn_st,ledAcai,ledGuarana);
	
		process(controlador) begin
			if (controlador = "00") then
				--A
				tVA <= 20;
				tVG <= 20;
				ledA <= ledAcai;
				ledG <= ledGuarana;
			elsif (controlador = "01") then
				--B
				tVA <= 30;
				tVG <= 10;
				ledA <= ledAcai;
				ledG <= ledGuarana;
			else
				--C
				ledA <= config_C;
				ledG <= config_C;
			end if;
		end process;
		
		process (clock_st) begin
			if (clock_st='1' and clock_st'event) then
				cont <= cont + 1;
				
				config_C(0) <= '0';
				config_C(2) <= '0';
				if(cont = 50000000) then
					config_C(1) <= '1';
				elsif (cont = 100000000) then
					config_C(1) <= '0';
					cont <= 0;
				end if;
				
			end if;
		end process;
	end rtl;