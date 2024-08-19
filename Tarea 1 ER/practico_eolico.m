clear all

%Primero cargamos los datos de viento
vientos=table2array(readtable('vientoslebu.txt'));

%% Ejercicio 1
velocidad=vientos(:,2)*1000/3600; % pasamos los datos a metros por segundo

desv=nanstd(velocidad); % desviacion estandar
media=nanmean(velocidad); % media


%graficamos para ver la distribucion de los valores

% Buscarmos el valor k de manera numerica 
k=1:0.01:2;% le damos valores al parametro de forma k, estos valores los iremos acotando cada vez más para encontrar una k más exacta

%calculamos la ecuacion de distribucion de k
A=gamma(1+(2./k));
B=gamma(1+(1./k)).^2;
C=A./B;
k1=sqrt(C-1); %ecuación para obtener la k, se compara con la razon entre la desviacion estandar y la media. Su intersección en el eje x representará el valor de k

x=desv/media;

figure(1)
plot(k,k1,'k','linewidth',2)
hold on
line([k(1) k(end)],[x x],'Color','red','linewidth',2) 
grid on
axis tight
xlabel('valores de k')
ylabel(' desviacion estandar / media','FontSize',12)
legend('valores de k','desv/mean')
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%
%otras forma de conseguir el k son
k2=(0.9874/(desv/media))^1.0983;
k3=(desv/media)^-1.086;

% No vale la pena calcularlo viendo el gráfico ya que las aproximaciones de k son bastante precisas 

%% Ejercicio 2

%Ejercicio A ; Rosa de los vientos
clearvars -except vientos

velocidad=vientos(:,2)*1/3.6;
direccion=vientos(:,1);
velocidad(end)=[];
direccion(end)=[];

vd=mean(reshape(velocidad,24,365)); % pasamos los datos de forma horaria a diaria
dd=mean(reshape(direccion,24,365));

wind_rose(dd,vd)

%% Ejercicio B ; Gráfico de diagrama de vector progresivo
%obtenemos las componentes x e y del viento

Vx=-velocidad.*sin(direccion*pi/180);
Vy=-velocidad.*cos(direccion*pi/180);

x=cumsum([0; Vx]);
y=cumsum([0; Vy]);

figure(2)
plot(x,y,'k-','linewidth',3)
xlabel('metros','FontSize',20)
ylabel('metros','FontSize',20)
grid on
axis tight

% ejercicio C ; Distribicion de weibull

clearvars -except velocidad 

figure(2)
histogram(velocidad,5)
xlabel('m/s')
ylabel('Numero de datos')


%% ecuacion de weibull; variable estandarizada

velocidad_ordenada=sort(velocidad); % Ordenamos los datos 
V_norm=velocidad_ordenada/nanmean(velocidad); % estandarizamos los datos
desv=nanstd(velocidad); 
media=nanmean(velocidad);
k=(0.9874/(desv/media))^1.0983; %Parametro de forma
c=1/gamma(1+1/k);%parametro de escala 

A=k/c;
B=(V_norm/c).^(k-1);
D=exp(-V_norm/c).^k;
weibull=A.*B.*D; % calculo de la distribución de weibull


figure(3)
plot(V_norm,weibull,'r-','linewidth',2)
xlabel('m/s')
ylabel('Probabilidad')
title('Distribución de weibull')

%%% otra forma de calcular weibull con dimensiones de m/s
velocidad=sort(velocidad);
c=media/gamma(1+1/k);
A=k/c;
B=(velocidad/c).^(k-1);
D=exp(-velocidad/c).^k;
weibull=A.*B.*D; 

figure(4)
yyaxis left;
plot(velocidad,weibull,'r*','linewidth',2)
hold on
xlabel('m/s')
ylabel('Probabilidad')
title('Distribución de weibull')

yyaxis right ;
histogram(velocidad,15)


%% Ejercicio D y E; porcentaje que el viento esté entre ciertos valores 

Vu=3; % velocidad minima
Vl=12; % velocidad maxima

t1=1-exp(-Vu/nanmean(velocidad)*gamma(1+1/k))^k
t2=(exp(-Vu/nanmean(velocidad)*gamma(1+1/k))^k)-(exp(-Vl/nanmean(velocidad)*gamma(1+1/k))^k)
% t1 seria el porcentaje del tiempo en el que el viento esté por debajo de
% 3 m/s por lo que al restarle 1 nos dará el porcentaje del tiempo que este
% sobre este valor

%% Ejercicio 3 ; calcular el promedio mensual del viento a diferentes alturas con diferentes suelos

% Tipo de terreno, Pasto corto  0.03
% Tipo de terreno, Bosque   1
% Asumimos 8 metros de altura z=8

z=[0.03 1];
h=[20 40 60 80];


for i=1:length(h)
v(:,i)=velocidad.*(log(h(i)/z(1))/log(8/z(1)));
end
% calculamos la velocidad promedio mensual
vd=squeeze(mean(reshape(v,24,365,4))); % pasamos los datos de forma horaria a diaria

c=[0 31 28 31 30 31 30 31 31 30 31 30 31];
d=cumsum(c);

for j=1:length(h)
 for i=1:12
    Vm(i,j)=nanmean(vd(d(i)+1:d(i+1),j));
 end
end

x=1:12;
meses={'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
color={'r','b','y','g'}
figure(2)
for i=1:length(h)
 plot(Vm(:,i),'--*','Color',color{i})
 hold on
end
xticks(x)
xticklabels(meses)
ylabel('Velocidad Viento m/s','FontSize',12)
legend(['Altura en metros ' num2str(h(1))],['Altura en metros ' num2str(h(2))],['Altura en metros ' num2str(h(3))],['Altura en metros ' num2str(h(4))])
hold off
grid on
ylim([0 10])

% parte 2; Calcular la potencia generada en MWh y pasarla a millones de
% pesos de un aerogenerador de tres aspas, cada aspa mide 35 metros.

rho=1.2; %densidad del aire
A=pi*35^2;  % Area de barrido


Ec=0.5*rho*A*nanmean(velocidad)^3; % potencia total del aire. usamos la velocidad media solo para resumir el ejercicio, 
% para ser más realistas deberiamos usar cada valor de velocidad por separada 
% e ignorar las velocidades menores a velocidad minima en la que funcine el aerogenerador, 
% ademas de tener que usar la velocidad a la altura por la que pase por el aerogenerador

P=Ec*0.4; % potencia que puede extraerse del aire


MW=P/1000000; % Transformamos a MW

MWh=MW*24*365; % Transformamos a MW-h, multiplicando por las horas. Se genera un total de 50.28 MWH por año 

Dinero=MWh*130000; %suponemos que un kwh cuesta 130 pesos, por lo que un Mwh costaria mil veces más osea 130000
  
