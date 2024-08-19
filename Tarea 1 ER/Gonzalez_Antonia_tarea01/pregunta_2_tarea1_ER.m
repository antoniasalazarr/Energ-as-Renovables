%% Ejercicio 2
clc
clear all 
close all

load rio_tolten.mat
tiempo= datevec(time);

index= find(tiempo(:,1)== 1981);
index2= find(tiempo(:,1)== 2010);

datos(:,1)= value(index(1):index2(end)); %datos del 1 de enero de 1981 al 31 de dic de 2010
%tiemp= time(index(1):index2(end));

tiempo= tiempo(index(1):index2(end),:,:);
clear index2 index time value

%% hacemos la matriz de promedios diarios para los 30 años (1981 a 2010)
%codigo de la ayudantía

c=0;
for i=1:12 %mes
    for j=1:31 %dia
        aux=find(tiempo(:,2)==i & tiempo(:,3)==j); 
        prom=mean(datos(aux));
        c=c+1; 
        media_diaria(c,1)=prom;
    end
end
clear aux i j c prom

%eliminamos los NaN que son fechas que no existen y la matriz queda de 366
aux= isnan(media_diaria);
media_diaria(aux)=[];

clear aux prom

%% codigo propio que hace lo mismo de la ayudantía: creé una matriz de dias x año,
%es decir, de 366 x 30 y se saqué el promedio por fila que seria el
%promedio de todos los 1 de enero, todos los 2 de enero, etc.

datos2= NaN(366,30);
for i=1981:2010
    for j=1:12 
        for k=1:31
            for c=1:length(tiempo)
                if tiempo(c,1)== i && tiempo(c,2)==j && tiempo(c,3) == k
                    datos2(datenum(i,j,k)-datenum(i,01,01)+1,i-1980)= datos(c);
                end
            end
        end
    end
end
clear i j k c 

% arreglamos la matriz por los años biciestos
datos3=datos2;
for i=1:30
    if isnan(datos3(end,i))
        datos3(61:end,i) = datos3(60:end-1,i);
        datos3(60,i) = NaN; % Poner NaN en la fila 60
    end
end
clear i j
% sacamos el promedio diario para los 30 años
for i=1:366 
    prom_diario(i,1)= mean(datos3(i,:),'omitnan');
end
clear i datos2
%% cauda clasificado y caudal promedio de los 30 años
meses = {'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'};

figure
subplot(1,2,1)
plot(1:366,prom_diario,'LineWidth',2,'Color','blue')
grid on
xticks(15:30:366)
xticklabels(meses)
xtickangle(45)
title('Caudal promedio (1981-2010)','FontSize',15)
xlabel('Meses')
ylabel('Caudal [m^3/s]','FontSize',13)
ylim([0 450])
xlim tight
%axis tight

subplot(1,2,2)
plot(1:366, sort(prom_diario,'descend'),'LineWidth',2,'Color','red')
grid on
%axis tight
xticks(15:30:366)
title('Caudal clasificado (1981-2010)','FontSize',15)
xlabel('Días del año')
ylabel('Caudal [m^3/s]','FontSize',13)
ylim([0 450])
xlim tight

%% eligiendo un año en específico --> 2000
figure
subplot(1,2,1)
plot(1:366,datos3(:,20),'LineWidth',2,'Color','blue')
grid on
xticks(15:30:366)
xticklabels(meses)
xtickangle(45)
title('Caudal promedio año 2000','FontSize',15)
xlabel('Meses')
ylabel('Caudal [m3/s]','FontSize',13)
%axis tight
ylim([0 800])
xlim tight

subplot(1,2,2)
plot(1:366, sort(datos3(:,20),'descend'),'LineWidth',2,'Color','red')
grid on
title('Caudal clasificado año 2000','FontSize',15)
xlabel('Días del año','FontSize',13)
ylabel('Caudal m3/s')
ylim([0 800])
xlim tight

%%
Q_ecologico= mean(datos)*0.1;
Q= prom_diario - Q_ecologico;

Q=sort(Q,'descend');
figure()
plot(Q,'r','LineWidth',1.5)
title('Calculo del caudal para obtener enegía','FontWeight','bold')
xlabel('N° de dias que se supera el caudal','FontWeight','bold')
ylabel('Caudal (m3/s)','FontWeight','bold')
line([0 366], [Q_ecologico Q_ecologico],'Color','k','LineWidth',1.5,'LineStyle', '--')
line([366-80 366-80], [0 max(Q)],'Color','b','LineWidth',1.5,'LineStyle', '--') %graficamos linea para Q80
line([366-100 366-100], [0 max(Q)],'Color','g','LineWidth',1.5,'LineStyle', '--') %graficamos linea para Q100
axis tight
ylim([0 max(Q)])
legend('Caudal clasificado - caudal ecológico','Caudal ecológico','Q80','Q100','Location','best')
% text(15,18,'Caudal ecologico')
% text((366-75),180,'Q80')
% text((366-95),200,'Q100')
grid minor

%del grafico se puede ver que:
Q80= 109.70;
Q100= 123;
%asi, el caudar que podria usarse para obtener energia seria:
Q_energia= (Q80+Q100)/2; %caudal de equipamiento


%% calculo de la potencia
H= 20;%metros
P=8.2*Q_energia*H; %= 19.081 kW
