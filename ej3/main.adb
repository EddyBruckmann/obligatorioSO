with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random;


procedure Main is
	task pasilloTambo is
		entry alPasillo (Vaca : in Integer);
		entry salirDelPasillo (Vaca : in Integer);
	end pasilloTambo;

	task mangaVacunas is
		entry entradaVacunacion (Vaca : in Integer);
		entry salidaVacunacion (Vaca: in integer);
	end mangaVacunas;

	task camion is
		entry vamosAlCamion (Vaca, NumCamion : in Integer);
	end camion;

	task body pasilloTambo is
		Vaca : Integer;
	begin
		loop
			select 
				accept alPasillo (Vaca : in Integer) do
					mangaVacunas.entradaVacunacion(Vaca);
				end alPasillo;

			or
				accept salirDelPasillo (Vaca : in Integer) do
					mangaVacunas.salidaVacunacion (Vaca);
				end salirDelPasillo;
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
					delay 0.1 + 3.0 * Duration (Ada.Numerics.Float_Random.Random(G));
					Put_Line("Vaca " & Integer'Image(Vaca) & " entra al vacunatorio");
					CantidadManga := CantidadManga +1;
				end entradaVacunacion;
			or
				accept salidaVacunacion (Vaca : in Integer) do
					Put_Line("Vaca " & Integer'Image(Vaca) & " sale del vacunatorio");
					CantidadManga := CantidadManga -1;
				end SalidaVacunacion;
			end select;
		end loop;
	end mangaVacunas;


	task body camion is
		Vaca : Integer;
		NumCamion : Integer;
	begin
		loop
			accept vamosAlCamion(Vaca, NumCamion : in Integer) do
				Put_Line("Vaca " & Integer'Image(Vaca) & " entro al camion " & Integer'Image(NumCamion));
			end vamosAlCamion;
		end loop;
	end camion;


	
begin
	for I in 1..100 loop
		pasilloTambo.alPasillo(I);
		pasilloTambo.salirDelPasillo(I);
		if I > 50 then
			camion.VamosAlCamion(I,2);
		else 
			camion.VamosAlCamion(I,1);
		end if;
	end loop;
end Main;
