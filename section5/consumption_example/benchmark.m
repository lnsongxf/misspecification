function [A, B, C_final, D_final, add_matrices] = benchmark( params,setup,data )

rho=params(1);
sigma_e1=params(2);
a_bar=params(3); 
y_bar=params(4); 
c_bar=params(5);  
sigma_meas_a=params(6);
sigma_e2=params(7);

G=0;

yT=1;
c=2;
a=3;
a_total=4;
c_total=5;
Ec=6;
yP=7;

g0=zeros(7,7);
g1=zeros(7,7);
C=zeros(7,1);
pi_matrix=zeros(7,1);
PSI=zeros(7,2);


%eq 16
 
g0(1,c)=1;
g0(1,Ec)=-1;



% eq 17
g0(2,a)=1;
g0(2,yT)=-y_bar;
g0(2,c)=c_bar;
g1(2,a)=a_bar;
PSI(2,2)=-a_bar*sigma_e2;



%   eq 18 
g0(3,yP)=1;
g1(3,yP)=1;
PSI(3,2)=sigma_e2;
C(3,1)=G;
   

%eq 19
g0(4,yT)=1;
g1(4,yT)=rho;
PSI(4,1)=sigma_e1;
%Ec

g0(5,c)=1;
g1(5,Ec)=1;
pi_matrix(5,1)=1;

%eq 20
g0(6,c_total)=1;
g0(6,c)=-1;
g0(6,yP)=-1;

%eq 21
g0(7,a_total)=1;
g0(7,a)=-1;
g0(7,yP)=-1;


%call gensys
 
 [C,Constant,D_sqr,fmat,fwt,ywt,gev,eu,loose]=gensys(g0,g1,C,PSI,pi_matrix);
 
 D=D_sqr*D_sqr';
if eu(1)~=1 || eu(2)~=1
    C=zeros(size(C)); 
    D=eps+zeros(size(C)); 
 end
  %now add intercept term
 C_final=zeros(8,8);
 C_final(1:7,1:7)=C;
 C_final(8,1:7)=Constant;
 C_final(8,8)=1;
 D_final=zeros(size(D,1)+1,size(D,2)+1);
 D_final(1:size(D,1),1:size(D,2))=D;
 
 
 
 
 A=zeros(3,8); 
 A(1,yP)=1; 
 A(1,yT)=1; 
 A(2,a_total)=1;
 A(3,c_total)=1;

 B=zeros(3,1);
B(2,1)=sigma_meas_a;


B=B*B';

add_matrices=[];