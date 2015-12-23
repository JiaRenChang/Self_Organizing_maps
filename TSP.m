clc
clear all
close all

%% generate city loc
city = 100;
for i=1:city
    cityx(i)=rand;
    cityy(i)=rand;
end
plot(cityx,cityy,'b.');

%% setting
alpha = 0.01;
G(1) = 30;

%% generate first weight
w_x(1)=0;
w_y(1)=0;
hold on;
memory(1) = 0;
generation(1) = 0; %remember the which epoch it borns 
maxiter = 500;


e=0;
D = false;
while e<maxiter || D~=true 
   n=[];
   e=e+1;
    for idd = 1 :length(memory)  %clear memory
       memory(idd) = 0;
    end
    G(e+1)=(1-alpha)*G(e); 
  for t = 1:city
    dup = false;
    %find closest node for city City(t)   
    distance=(cityx(t)-w_x).^2+(cityy(t)-w_y).^2; 
            minx=1;
            min_dis = distance(minx);    
            for j1=1:size(w_x,2)
                    if distance(j1)<min_dis
                        min_dis = distance(j1);
                        minx = j1;
                    end
            end
            j1star= minx;
    %move node
         %creation of nodes
               if memory(j1star) >= 1  % if find same node, duplicate it
                  dup = true;
                  w_x = [w_x(1:j1star) w_x(j1star) w_x(j1star+1:end)];
                  w_y = [w_y(1:j1star) w_y(j1star) w_y(j1star+1:end)];
                  distance = [distance(1:j1star) distance(j1star) distance(j1star+1:end)];
                  memory = [memory(1:j1star) 0 memory(j1star+1:end)];
                  generation = [generation(1:j1star) 0 generation(j1star+1:end)];
                  j1star = j1star+1; %duplicated node
               end
            
            
            %update 
            for idx = 1 : size(w_x,2)  
                n(idx) = min (mod((idx-j1star),size(w_x,2)),mod((j1star-idx),size(w_x,2)));
            end
            f = (1/sqrt(2))*exp(-(n.^2)/G(e)^2);
            % only update non-inhibited node (n~=0)
            for q = 1 : size(w_x,2) 
                if dup == true
                    if q ~= j1star || j1star-1
                        w_x(q)=w_x(q)+f(q)*(cityx(t)- w_x(q));
                        w_y(q)=w_y(q)+f(q)*(cityy(t)- w_y(q)); 
                    end
                else
                    w_x(q)=w_x(q)+f(q)*(cityx(t)- w_x(q));
                    w_y(q)=w_y(q)+f(q)*(cityy(t)- w_y(q)); 
                end
            end
%             if dup == true
%               memory(j1star-1) =  memory(j1star-1) + 1;
%             end
            memory(j1star) =  memory(j1star) + 1;
            
  end
  %delete
  generation= generation + ones(size(generation));
  generation(memory>0) = 0;
                  w_x(generation>3) = [];
                  w_y(generation>3) = [];
                  distance(generation>3) = []; 
                  memory(generation>3) = []; 
                  generation(generation>3) = [];
  D= true;                
  for u = 1: size(memory,2)
     if memory(u) ~= 1
       D = false;
     end
  end
  
%pause(0.2)
plot(cityx,cityy,'b.');
hold on; 
plot(w_x,w_y,'ro'); 
plot([w_x w_x(1)],[w_y w_y(1)],'k','linewidth',2);  
hold off
title(['iter=' num2str(e) ' ring=' num2str(size(w_x,2))]);
drawnow    
end
ringx=[w_x w_x(1)];
ringy=[w_y w_y(1)];
tourlength = 0;
for a = 1 : city
   tourlength =  tourlength + sqrt((ringx(a)-ringx(a+1))^2+(ringy(a)-ringy(a+1))^2);
end
tourlength