with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random;




procedure Main is

	cantVacas : Integer := 100;

	package counter is
		function get_next return integer;
		private
		data: integer := 0;
	end counter;
	package body counter is
		function get_next return integer is
			return_val: integer;
		begin
			return_val := data;
			data := data + 1;
		return return_val;
		end get_next;
	end counter;

	task pasilloTambo is
		entry alPasillo (Vaca : in Integer);
		entry salirDelPasillo (Vaca : in Integer);
	end pasilloTambo;

	task mangaVacunas is
		entry entradaVacunacion (Vaca : in Integer);
		entry salidaVacunacion (Vaca: in integer);
	end mangaVacunas;

	task salaOrdeniacion is
		entry entrarAOrdeniar (Vaca : in Integer);
		entry salirDeOrdeniar (Vaca : in Integer);
	end salaOrdeniacion;

	task type camion(Num: Integer) is
		entry vamosAlCamion (Vaca : in Integer);
	end camion;

	Camion1: camion(1);
	Camion2: camion(2);

	task type vaca (numero: integer:= 1+( counter.get_next mod cantVacas)) is
	
	end vaca;

	task body pasilloTambo is
		Vaca : Integer;
		S : Integer := 0;
	begin
		loop
			select 
				when S = 0 =>accept alPasillo (Vaca : in Integer) do
					S:= 1;
				end alPasillo;

			or
				accept salirDelPasillo (Vaca : in Integer) do
					S:= 0;
				end salirDelPasillo;
			or
				terminate;
			end select;
		end loop;

	end pasilloTambo;

	task body mangaVacunas is
		G: Ada.Numerics.Float_Random.Generator;
		Vaca : Integer;
		CantidadManga : Integer := 0;
	begin
		Ada.Numerics.Float_Random.Reset(G);
		loop
			select 
				when CantidadManga < 5 => accept entradaVacunacion(Vaca : in Integer) do
					Put_Line("Vaca " & Integer'Image(Vaca) & " entra al vacunatorio");
					CantidadManga := CantidadManga +1;
				end entradaVacunacion;
			or
				accept salidaVacunacion (Vaca : in Integer) do
					Put_Line("Vaca " & Integer'Image(Vaca) & " sale del vacunatorio");
					CantidadManga := CantidadManga -1;
				end SalidaVacunacion;
			or
				terminate;
			end select;
		end loop;
	end mangaVacunas;

	task body salaOrdeniacion is
		G: Ada.Numerics.Float_Random.Generator;
		Vaca : Integer;
		cantidadLactando : Integer := 0;
	begin
		loop
			select when cantidadLactando < 15 => accept entrarAOrdeniar(Vaca : in Integer) do
				Put_Line("Vaca " &Integer'Image(Vaca) & " se está ordeñando");
				cantidadLactando := cantidadLactando+1;
				end entrarAOrdeniar;
			or
				accept salirDeOrdeniar(Vaca : in Integer) do
				Put_Line("Vaca " & Integer'Image(Vaca) & " termió de ordeñarse");
				cantidadLactando := cantidadLactando-1;
				end salirDeOrdeniar;
			or
				terminate;
			end select;
		end loop;
	end salaOrdeniacion;


	task body camion is
		Vaca : Integer;
		Capacidad: Integer := 50;
	begin
		loop
			select 
				when Capacidad > 0 => accept vamosAlCamion(Vaca: in Integer) do
					Put_Line("Vaca " & Integer'Image(Vaca) & " entró al camion " & Integer'Image(Num));
					Capacidad:=Capacidad-1;
					end vamosAlCamion;
			or
				terminate;
			end select;
		end loop;
	end camion;

	task body vaca is
		G: Ada.Numerics.Float_Random.Generator;
		QuePrimero : Boolean;
	begin
		Ada.Numerics.Float_Random.Reset(G);
		quePrimero := Ada.Numerics.Float_Random.Random(G) > 0.5;

		if QuePrimero then

			salaOrdeniacion.entrarAOrdeniar(numero);
			delay 0.1 + 3.0 * Duration (Ada.Numerics.Float_Random.Random(G));
			salaOrdeniacion.salirDeOrdeniar(numero);


			pasilloTambo.alPasillo(numero);
			pasilloTambo.salirDelPasillo(numero);
			mangaVacunas.entradaVacunacion(numero);

			delay 0.1 + 2.0 * Duration (Ada.Numerics.Float_Random.Random(G));

			pasilloTambo.alPasillo(numero);
			pasilloTambo.salirDelPasillo(numero);
			mangaVacunas.salidaVacunacion(numero);

		else

			pasilloTambo.alPasillo(numero);
			pasilloTambo.salirDelPasillo(numero);
			mangaVacunas.entradaVacunacion(numero);

			delay 0.1 + 2.0 * Duration (Ada.Numerics.Float_Random.Random(G));

			pasilloTambo.alPasillo(numero);
			pasilloTambo.salirDelPasillo(numero);
			mangaVacunas.salidaVacunacion(numero);

			salaOrdeniacion.entrarAOrdeniar(numero);
			delay 0.1 + 3.0 * Duration (Ada.Numerics.Float_Random.Random(G));
			salaOrdeniacion.salirDeOrdeniar(numero);
		end if;		

		loop
			select
				Camion1.vamosAlCamion(numero);
				exit;
			or delay 0.1;
				select
					Camion2.vamosAlCamion(numero);
					exit;
				else
					null; 
				end select;
			end select;
		end loop;
	end vaca;

type listaVacas is array (Integer range <>) of vaca;

misVacas : listaVacas (1 .. cantVacas);
	
begin
	null;		
end Main;
