clc
clear all
close all

[num1,txt1] = xlsread('lab3tc.xlsx');
tiempo1 = num1(:,1);
ta = num1(:,2);
te = num1(:,3);
long = size(ta);
[num2,txt2] = xlsread('Aire.xlsx');
densidadi = num2(:,2);
Cpo = num2(:,3);
uo = num2(:,4);
vo = num2(:,5);
ki = num2(:,6);
Pri = num2(:,8);

pr =  zeros(long(1,1),1);
densidad =  zeros(long(1,1),1);
k =  zeros(long(1,1),1);
betha =  zeros(long(1,1),1);
v = zeros(long(1,1),1);
prom = zeros(long(1,1),1);

for i = 1:99
    T =  ta(i,1) + 273;
    betha(i,1) = 1/T;
    prom(i,1) = (te(i,1)+ ta(i,1))/2;
if prom(i,1)<=21.5
densidad(i,1) = densidadi(1,1);
k(i,1) = ki(1,1);
pr(i,1) = Pri(1,1);
v(i,1) = vo(1,1);
elseif prom(i,1)>21.5 && prom(i,1)<=22.5 
densidad(i,1) = densidadi(2,1);
k(i,1) = ki(2,1);
pr(i,1) = Pri(2,1);
v(i,1) = vo(2,1);
elseif prom(i,1)>22.5 && prom(i,1)<=23.5
densidad(i,1) = densidadi(3,1);
k(i,1) = ki(3,1);
pr(i,1) = Pri(3,1);
v(i,1) = vo(3,1);
elseif prom(i,1)>23.5 && prom(i,1)<=24.5
densidad(i,1) = densidadi(4,1);
k(i,1) = ki(4,1);
pr(i,1) = Pri(4,1);
v(i,1) = vo(4,1);
elseif prom(i,1)>24.5 && prom(i,1)<=25.5
densidad(i,1) = densidadi(5,1);
k(i,1) = ki(5,1);
pr(i,1) = Pri(5,1);
v(i,1) = vo(5,1);
elseif prom(i,1)>25.5 && prom(i,1)<=27
densidad(i,1) = densidadi(6,1);
k(i,1) = ki(6,1);
pr(i,1) = Pri(6,1);
v(i,1) = vo(6,1);
end  
end

%================== Cálculo del Grassoff ===================

g=9.81; %m/s
tetha=te(1:99)-ta(1:99); %K
L=0.01; %m

%================== Datos iniciales sin el #100 ===================

betha2=betha(1:99);
tetha2=tetha(1:99);
v2=v(1:99);
pr2=pr(1:99);
k2=k(1:99);
ta2=ta(1:99);
te2=te(1:99);

%================== Cálculo del Grassoff ===================

Gr=(g*betha2.*tetha2.*(L^3))./(v2.^2);
GrPr=Gr.*pr2;

%================== Cálculo del Nussel ===================

Nu=2+((0.589.*(GrPr.^(0.25)))./((1+((0.469./pr2).^(9/16))).^(4/9))); %Vector

NuProm=mean(Nu) %Promedio

%================== Cálculo del h convectivo natural ===================

h=(Nu.*k2)./L; %Vector
   
hcvprom=mean(h)  %Promedio

Tm=((ta2+273.15)+(te2+273.15))/2;
hr=4*0.9*(5.67*(10^-8))*(Tm.^3); %Vector

hrprom=mean(hr)  %Promedio

%========================== Cálculos experimentales ========================

rho=8300; %kg/m3  Densidad
vol=(4/3)*pi*((L/2)^3); %m3   Volumen de esfera
m=rho*vol; %kg  masa
cp=419; %J/kg*°C  calor especifico
A=pi*((L/2)^2); %m2  Area
tsta=(te2-ta2); %°C  Diferencia de temperatura entre superficie y esfera

x=(m*cp)./(A.*tsta); %Variable auxiliar 

tiempo2=tiempo1(1:99);
dTdt0=polyfit(tiempo2,te2,2);
dTdt1=polyval(dTdt0,tiempo2);

dTdt=(dTdt0(1,1))/60

hcexp=(x*dTdt)-hr;
hcmprom=mean(hcexp)

%============================= Gráficos ================================

figure(1)
hold on
plot(tiempo2,dTdt1)
plot(tiempo2,te2,'rx')

xlabel('Tiempo [min]','FontName','TimesNewRoman','FontSize',12)
ylabel('Temperatura [°C]','FontName','TimesNewRoman','FontSize',12)
legend('Ajuste polinomial','Mediciones experimentales','FontName','TimesNewRoman','FontSize',12)
title('Temperatura de la esfera en el tiempo.','FontName','TimesNewRoman','FontSize',14)
hold off

figure(2)
hold on
plot(tiempo2,ta2)
plot(tiempo2,te2)

xlabel('Tiempo [min]','FontName','TimesNewRoman','FontSize',12)
ylabel('Temperatura [°C]','FontName','TimesNewRoman','FontSize',12)
legend('Temperatura del aire','Temperatura de la esfera','FontName','TimesNewRoman','FontSize',12)
title('Temperaturas de la esfera y el aire.','FontName','TimesNewRoman','FontSize',14)
hold off

figure(3)
hold on
plot(tiempo2,Nu)
xlabel('Tiempo [min]','FontName','TimesNewRoman','FontSize',12)
ylabel('[-]','FontName','TimesNewRoman','FontSize',12)
legend('Nu','FontName','TimesNewRoman','FontSize',12)
title('Número de Nussel.','FontName','TimesNewRoman','FontSize',14)
hold off

figure(4)
hold on
plot(tiempo2,h)
xlabel('Tiempo [min]','FontName','TimesNewRoman','FontSize',12)
ylabel('[W/m^2K]','FontName','TimesNewRoman','FontSize',12)
legend('h_c_n','FontName','TimesNewRoman','FontSize',12)
title('h de convección natural.','FontName','TimesNewRoman','FontSize',14)
hold off

figure(5)
hold on
plot(tiempo2,hr)
xlabel('Tiempo [min]','FontName','TimesNewRoman','FontSize',12)
ylabel('[W/m^2K]','FontName','TimesNewRoman','FontSize',12)
legend('h_r','FontName','TimesNewRoman','FontSize',12)
title('h de radiación.','FontName','TimesNewRoman','FontSize',14)
hold off

figure(6)
hold on
plot(tiempo2,hcexp)
xlabel('Tiempo [min]','FontName','TimesNewRoman','FontSize',12)
ylabel('[W/m^2K]','FontName','TimesNewRoman','FontSize',12)
legend('h_c_v_m','FontName','TimesNewRoman','FontSize',12)
title('h de convección mixta experimental.','FontName','TimesNewRoman','FontSize',14)
hold off

hcfpe=sqrt((hcmprom^2)-(hcvprom^2)) %Flujo perpendicular
hcfpa=hcmprom+hcvprom %Flujo paralelo en mismo sentido
hcfpa2=hcmprom-hcvprom %Flujo paralelo en sentido opuesto