%--------------------------------------------------------------------------
%   Calculating the natural frequencies of a cantilever beam              
%   length = 35 cm, width = 10 cm, thickness = 1cm                 
%                                             
%                                                              
%               /│                                             
%               /│=============================                           
%               /│             EI                │            
%               /│=============================                         
%               /│                                             
%                                                               
%                                                
%   PURPOSE  :1.Get the natural frequencies of the Euler-Bernoulli beam.   
%              2.Draw the mode shapes of the Euler-Bernoulli beam.        
%                                                                          
%   REFERENCE:1.K matrix assembly refer to DAVID S. BURNETT, "Finite       
%                Element Analysis," 1987, AT&T Bell Laboratories, p363-370. 
%               2.M & K matrices assembly refer to J.N.REDDY,"An Introduction
%                to the Finite Element Method",1993,McGraw-Hill,p150-154,   
%                p225-227,p237                                   
%   Edit: RenYu-Chen                                                       
%   DATE : 12/9/2004                                           
%--------------------------------------------------------------------------
clear all;clf;
format long e;
%
% --------------------------------------------------------------------------
% Input data of the cantilever beam
% --------------------------------------------------------------------------
% UNIT:M.K.S.
 E=210*10^9;         % Young's modulus:N/m^2
 Wb=4/100;          % beam width:m
 Tb=4/100;           % beam thickness:m
 Lb=25/100;          % beam length:m
 pb=7860;            % beam density (per unit volume):kg/m^3
 I=Wb*Tb^3/12;       % moment of inertia:m^4
 A=Wb*Tb;            % cross section area of the beam:m^2
%
% --------------------------------------------------------------------------
% Defining the elements and nodes 
% --------------------------------------------------------------------------
% where we use 4 elements
N_elem=4; % elements
node=zeros(N_elem+1,2); % nodes
for i=1:N_elem+1
   node(i,1)=i;
   node(i,2)=Lb/N_elem*(i-1);
end
 NUM_NODE=length(node);   % the size of nodes
 NUM_ELEM=length(node)-1; % the size of elements
 matrix_size=2*NUM_ELEM+2;
%
% --------------------------------------------------------------------------
% Initializes K and F matrice
% --------------------------------------------------------------------------
%
 M=zeros(matrix_size,matrix_size);
 K=zeros(matrix_size,matrix_size);
%
% --------------------------------------------------------------------------
% Assembling of K and M matrices
% --------------------------------------------------------------------------
%
% (1). assembly of K matrix
 ELNO=0; % ELNO:the ith element
 for ii=1:2:matrix_size-3  
    ELNO=ELNO+1;
    [KE]=k_elemu(node(ELNO,2),node(ELNO+1,2),Lb,E,I);
    %[K]=mtxasmby(K,KE,ii);  % matrix assembly by calling "mtxasmby.m"
    K((ELNO*2-1):(ELNO+1)*2,(ELNO*2-1):(ELNO+1)*2)=K((ELNO*2-1):(ELNO+1)*2,(ELNO*2-1):(ELNO+1)*2)+KE
 end % end of FOR loop -- assembly of K matrix
%
% (2). assembly of M matrix
 ELNO=0; % ELNO:the ith element
 for ii=1:2:matrix_size-3  
    ELNO=ELNO+1;
    [ME]=m_elemu(node(ELNO,2),node(ELNO+1,2),Lb,pb,A);
    %[M]=mtxasmby(M,ME,ii);  % matrix assembly by call mtxasmby.m
    M((ELNO*2-1):(ELNO+1)*2,(ELNO*2-1):(ELNO+1)*2)=M((ELNO*2-1):(ELNO+1)*2,(ELNO*2-1):(ELNO+1)*2)+ME;
 end % end of FOR loop -- assembly of M matrix
%
% --------------------------------------------------------------------------
% Imposing the essential Boundary Conditions
% --------------------------------------------------------------------------
% In this case, one end of the Euler-Bernoulli beam is fixed.
% The other end is free. Therefore, the K and M matrices can be deleted 
% 2 rows and 2 columns. In other words, we can delete the firstly and  
% secondly two rows and columns of the matrices.     
%
% K_bc: apply BCs to the K_matrix
% M_bc: be reduced orders as apply BCs to the K_matrix
%
  K_bc=zeros(matrix_size-2,matrix_size-2);
  M_bc=zeros(matrix_size-2,matrix_size-2);
%
  K_bc=K(3:matrix_size,3:matrix_size);
  M_bc=M(3:matrix_size,3:matrix_size);
%
% --------------------------------------------------------------------------
% Calculate eigenvalues by the finite element formulation 
% --------------------------------------------------------------------------
%  
  ei=eig(K_bc,M_bc); % eigenvalues
% sorted natural angular frequencies [rad/s] 
  ef=sort(real(sqrt(ei))); 
% sorted natural angular frequencies [Hz]
  f=ef/(2*pi);
%
% --------------------------------------------------------------------------
% Compare the first six modal testing and F.E.M values of frequencies with 
% theoretical values.
% --------------------------------------------------------------------------
%
% Theoretical calculated values are expressed in xbar(i) = lambda(i)*L 
% variables and were copied here
beta= [1.875104068706770e+000 ...
       4.694091132933031e+000 ...
       7.854757438070675e+000 ...
       1.099554073487850e+001 ...
       1.413716839104652e+001 ...
       1.727875953327674e+001  ];
% first six frequencies of modal testing 
modal_text_f= [ 28.9 ...
                180 ...
                506 ...
                992 ...
                1640 ...
                2440 ];
% Modal testing calculated values are expressed in xbar_ex(i) = lambda_ex(i)*L 
% variables and were copied here
beta_ex= sqrt(modal_text_f*2*pi/sqrt(E*I/(pb*A*Lb^4)));
% auxiliary constants
  c0=sqrt(E/pb); 
   j=sqrt(I/A); 
  b2=beta.*beta;
  b2_ex=beta_ex.*beta_ex;
%
  om=b2*c0*j/(Lb^2)/(2*pi);      % theoretical calculated angular frequencies [Hz]
  om_ex=b2_ex*c0*j/(Lb^2)/(2*pi); % modal test calculated angular frequencies [Hz]
%
% --------------------------------------------------------------------------
% plot first six theoretical, modal testing and FEM natural frequencies 
% --------------------------------------------------------------------------
%
ix=1:6;
figure(1); subplot(2,1,1)
plot( ix,om(ix),'r-', ix, om_ex(ix),'b*-',ix,f(ix),'ko')
title('Frequencies \omega','fontsize',18);
xlabel('counter','fontsize',18); 
ylabel('angular frequencies','fontsize',18);
legend('Theoretical', 'Modal texting','FEM');
% --------------------------------------------------------------------------
% compute and plot relative errors for the first 6 frequencies
% --------------------------------------------------------------------------
r=zeros(size(ix));
for i=ix
    r(i)=100*(f(i)-om(i))/om(i);
    r_ex(i)=100*(abs(om_ex(i)-om(i)))/om(i);
end
figure(1); subplot(2,1,2)
plot(ix,r_ex,'b*-',ix,r,'ro-')
title('relative errors [%]','fontsize',18);
xlabel('counter','fontsize',18);
ylabel('[%]','fontsize',18);
legend('relative errors for Modal testing','relative errors for FE');
% print results for the first 6 frequencies
disp(' ======================= relative errors [%] ======================= ')
disp('          counter,            Theoretical frequencies, Modal testing frequencies,    FE frequencies,     relative errors for Modal test[%], relative errors for FE[%]')
disp([ix' om(ix)' om_ex(ix)' f(ix)  r_ex'  r'])
%
% --------------------------------------------------------------------------
%  Draw the first six Modal shape 
% --------------------------------------------------------------------------
%
%  modes(1:6): the first six modes in Hertz
%  modeshapes(6, 10) : the vibration mode shapes of the first six modes
%
modes=zeros(6,1); 
modeshapes=zeros(6,N_elem);
modes_ex=zeros(6,1); 
modeshapes_ex=zeros(6,N_elem);
modes_fe=zeros(6,1); 
modeshapes_fe=zeros(6,N_elem);
% loop over the six modes
ix=1:6;
beta_fe=sqrt(f(ix)'*2*pi/sqrt(E*I/(pb*A*Lb^4)));
for  i=ix;
     modes(i) = beta(i)^2 * sqrt(E*I/(pb*A*Lb^4));
     modes(i) = modes(i)/(2*pi);
     modes_ex(i) = beta_ex(i)^2 * sqrt(E*I/(pb*A*Lb^4));
     modes_ex(i) = modes_ex(i)/(2*pi);
     modes_fe(i) = beta_fe(i)^2 * sqrt(E*I/(pb*A*Lb^4));
     modes_fe(i) = modes_fe(i)/(2*pi); 
     % coefficients  for  computing  mode  shape
     betaL=beta(i);
     betaL_ex=beta_ex(i);
     betaL_fe=beta_fe(i);
     %
     a1 = sin(betaL) - sinh(betaL); 
     a2 = cos(betaL) + cosh(betaL);
     a1_ex = sin(betaL_ex) - sinh(betaL_ex);
     a2_ex = cos(betaL_ex) + cosh(betaL_ex);
     a1_fe = sin(betaL_fe) - sinh(betaL_fe);
     a2_fe = cos(betaL_fe) + cosh(betaL_fe);
     %
     x = 0;
     x_ex=0;
     x_fe=0;
     increment = Lb/N_elem;
     % compute modeshapes for j =1:5,
          for  j =1:N_elem
               y = a1*(sin(x) - sinh(x));
               y = y +a2*(cos(x) - cosh(x)); 
               x = x + (beta(i)/Lb)*increment;
               modeshapes(i,j) = y;
               %
               y_ex = a1_ex*(sin(x_ex) - sinh(x_ex));
               y_ex = y_ex +a2_ex*(cos(x_ex) - cosh(x_ex)); 
               x_ex = x_ex + (beta_ex(i)/Lb)*increment;
               modeshapes_ex(i,j) = y_ex;
               %
               y_fe = a1_fe*(sin(x_fe) - sinh(x_fe));
               y_fe = y_fe +a2_fe*(cos(x_fe) - cosh(x_fe));
               x_fe = x_fe + (beta_fe(i)/Lb)*increment;
               modeshapes_fe(i,j) = y_fe;
% increment the beam span by 5 intervals for plotting
beamspan=(1:N_elem)*(1/N_elem)*Lb;
%
% plot the first six mode shape;

for s=1:6
subplot(2, 3, s)
plot(s)
figure(i)
ymax =max(abs(modeshapes(i,:)));
ymax_ex =max(abs(modeshapes_ex(i,:)));
ymax_fe =max(abs(modeshapes_fe(i,:)));
plot( beamspan, modeshapes(i,:)/ymax,'r-', beamspan, modeshapes_ex(i,:)/ymax_ex,'b-.', beamspan, modeshapes_fe(i,:)/ymax_fe,'go');
grid on;
ylabel('modeshape  amplitude','fontsize',5);
xlabel('beam  span [m]','fontsize',5);
title(['Cantilever Beam, Mode ',num2str(i)],'fontsize',5);
end
end;
end
% end of porgram

% k_elemu
function [KE]=k_elemu(prenode,postnode,Lb,E,I)
% PURPOSE : This is a subprogram as for Stiffness matrice
%
%  K=[ 12   6*lb    -12    6*lb
%           4*lb^2  -6*lb  2*lb^2  
%                    12   -6**lb
%      symmetric           4*lb^2  ];      
%
  l=postnode-prenode;  
  lb=l/Lb;
     % the length of present element per unit length, lb:length_bar
  KE(1,1)=12     ;                
  KE(2,1)=-6*lb  ; KE(2,2)=4*lb^2 ; 
  KE(3,1)=-12    ; KE(3,2)=6*lb   ; KE(3,3)=12     ; 
  KE(4,1)=-6*lb  ; KE(4,2)=2*lb^2 ; KE(4,3)=6*lb   ; KE(4,4)=4*lb^2;
  KE=KE/lb^3*E*I/Lb^3;
for i=2:4
    for j=1:i-1
        KE(j,i)=KE(i,j);
    end
end
end

% m_elemu
function [ME]=m_elemu(prenode,postnode,Lb,pb,A)
% PURPOSE : This is a subprogram as for Mass matrice
%
%  M=1/420[ 156  22*lb   54     -13*lb
%                4*lb^2  13*lb  -3*lb^2  
%                        156    -22*lb
%           symmetric            4*lb^2];      
%

    l=postnode-prenode; 
    lb=l/Lb;
       % the length of the present element per unit length, lb:length_bar
    ME(1,1)=156    ;
    ME(2,1)=22*lb  ; ME(2,2)=4*lb^2 ; 
    ME(3,1)=54     ; ME(3,2)=13*lb  ; ME(3,3)=156    ; 
    ME(4,1)=-13*lb ; ME(4,2)=-3*lb^2; ME(4,3)=-22*lb ; ME(4,4)=4*lb^2 ;
    ME=ME*lb/420*pb*A*Lb;
    for i=2:4
      for j=1:i-1
          ME(j,i)=ME(i,j);
      end
    end
end