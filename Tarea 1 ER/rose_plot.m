function rose_plot(velocidad, direccion)
    % Convertir la dirección del viento de grados a radianes
    direccion_rad = deg2rad(direccion);
    
    % Crear un vector de direcciones para el gráfico de rosa
    num_bins = 36; % Número de divisiones en el gráfico de rosa
    direcciones = linspace(0, 2*pi, num_bins+1);
    
    % Contar la frecuencia de cada dirección del viento
    frecuencia = zeros(1, num_bins);
    for i = 1:length(velocidad)
        [~, idx] = min(abs(direccion_rad(i) - direcciones));
        frecuencia(idx) = frecuencia(idx) + velocidad(i);
    end
    
    % Generar el gráfico de rosa de los vientos
    polarplot(direcciones, frecuencia, 'r');
    title('Rosa de los Vientos');
    thetalim([0 360]);
    rticks(0:10:max(frecuencia));
    rticklabels(0:10:max(frecuencia));
    thetaticks(0:30:330);
    thetaticklabels({'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'});
end
