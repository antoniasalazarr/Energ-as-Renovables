% ejercicio 3
clear all
load EC_series.mat
tiempo=datevec(time);

%% para escoger un año en especifico
for j=2000:2019
year=j;
i=find(tiempo(:,1)==year);
%% graficar ese año en especifico
figure(j)
subplot(1,2,1)
plot(datetime(tiempo(i,:)),value(i),'k')
ylabel('Caudal (m3/s)','FontSize',16,'FontWeight','bold')
title(['Caudal diario ' num2str(year)],'FontSize',18,'FontWeight','bold')
axis tight
grid on

%% graficamos los caudales clasificados del año 'year'
Qclasi=sort(value(i),'descend');

subplot(1,2,2)
plot(Qclasi,'k','LineWidth',1.5)
title(['Caudales clasificados para el año ' num2str(year)],'FontSize',18,'FontWeight','bold')
xlabel('N° de dias que se supera el caudal','FontSize',16,'FontWeight','bold')
ylabel('Caudal (m3/s)','FontSize',16,'FontWeight','bold')
axis tight
grid on
end

%% Para calcular los caudales diarios clasificados debemos promediar los dias de todos los años 

% buscamos la posicion para todos los primeros de enero
c=0;
for i=1:12
mes=i;
for j=1:31
dia=j;

k=tiempo(:,2)==mes & tiempo(:,3)==dia; % creamos una matriz logica de 0 y 1, donde los 1 corresponderán al dia en especifico que buscamos en cada ciclo 

x=mean(value(k)); % value(k) tendrá los valores de caudal de todos los años de un dia especifico
% ¿ que pasara cuando j e i no representen ningunca fecha ( 31 de febrero no existe por ejemplo)?
% como k no tiene valor, es una matriz vacia. y la media de una
% matriz vacia  es NaN. Así que cada NaN representará valores que no
% existen
c=c+1; % creamos un contador para ir guardando las variables
media_diaria(c)=x;
end
end

% ahora quitamos los NaN y nos quedamos con un vector de 366 dias, ya que
% el codigo promediara todos los dias que existen y que hubieron datos, por
% ende hay aproximadamente 17 dias viciesto que igual cuentan.
i=isnan(media_diaria);
media_diaria(i)=[];

clearvars -except media_diaria tiempo value


% para graficarlo buscamos un año bisiesto ya que mi vector de caudal tiene
% 366 datos y necesitamos que el vector tiempo tenga la misma longitud
% esto solo lo hacemos para que en el eje x aparezcan los meses de un año
% cualquiera ( podria ser 2016 como 2012 o 2000)
year=2016;
i=find(tiempo(:,1)==year);
fechas=datetime(tiempo(i,:));

figure(1)
subplot(1,2,1)
plot(datenum(fechas),media_diaria,'r')
datetick('x','mmm')
ylabel('Caudal (m3/s)','FontSize',16,'FontWeight','bold')
title(['Caudal promedio diario'],'FontSize',18,'FontWeight','bold')
axis tight
grid on

%% graficamos los caudales clasificados del año 'year'
Qclasi=sort(media_diaria,'descend');

subplot(1,2,2)
plot(Qclasi,'r','LineWidth',1.5)
title(['Caudales clasificados para caudal diario promedio'],'FontSize',18,'FontWeight','bold')
xlabel('N° de dias que se supera el caudal','FontSize',16,'FontWeight','bold')
ylabel('Caudal (m3/s)','FontSize',16,'FontWeight','bold')
axis tight
grid on

% calculamos el caudal de equipamiento y el ecologico

Qecologico=mean(value)*0.1; % Caudal ecologico, minimo de caudal que debe circular por el rio

Q=media_diaria-Qecologico; % le quitamos este caudal al caudal de equipamiento
%  Una vez que se ha descontado el caudal ecologico a la curva de caudales clasificados, se elige ´
% el posible caudal de equipamiento en el intervalo de la curva comprendido entre el Q80 y el Q100,
% siendo el Q80 el caudal minimo que circula por el rio durante 80 dias al año y el Q100 el que circula durante
% 100 dias al año ( Apuntes de Dante pag.9)

Q=sort(Q,'descend');
figure(3)
plot(Q,'r','LineWidth',1.5)
title(['Caudales clasificados para caudal diario promedio'],'FontSize',18,'FontWeight','bold')
xlabel('N° de dias que se supera el caudal','FontSize',16,'FontWeight','bold')
ylabel('Caudal (m3/s)','FontSize',16,'FontWeight','bold')
line([0 366], [Qecologico Qecologico])
line([366-80 366-80], [0 max(Q)])
line([366-100 366-100], [0 max(Q)])
axis tight
ylim([0 max(Q)])
text(15,18,'Caudal ecologico')

text((366-75),180,'Q80')
text((366-95),200,'Q100')
grid off

% Para calculo de la potencia hidromotriz usamos 
Qequipamiento=(Q(366-80)+Q(366-100))/2; 

%Para calculo del potencial hidromotriz 
H=1; % H será nuestra pendiente 
P=8.2*Qequipamiento*H % en Kw

%% buscamos en la pagina las coordenadas del lugar y calculamos lo que nos piden con Google Earth
% en este ejemplo la estación es : Caudal del rio MAIPO en el MANZANO (DGA)
% 33.5939°S, 70.3792°O a 850 m de altitud
% usamos la herramienta de "regla" ubicada en la interfaz de Google Earth y
% podemos con ella medir la longitud del rio y la pendiente 