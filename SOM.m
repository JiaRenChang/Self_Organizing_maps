clc
clear all
close all
%% setting
Neighbor = 8;  % Neighbor = 2 => linear topology   ; = 4 => 4 direction ;  = 8 => 8 direction
N_data = 10000;
gain = 1;
region = 5;

%% generating data
for i=1:N_data
    datax(i)=rand;
    datay(i)=rand;
end
%plot(datax,datay,'b.');

%% initial weight
w_x = rand(10,10);
w_y = rand(10,10);
switch Neighbor
    case 2 % linear
       w_x = [w_x(1,1:10),fliplr(w_x(2,1:10)),w_x(3,1:10),fliplr(w_x(4,1:10)),w_x(5,1:10),fliplr(w_x(6,1:10)),w_x(7,1:10),fliplr(w_x(8,1:10)),w_x(9,1:10),fliplr(w_x(10,1:10))];  
       w_y = [w_y(1,1:10),fliplr(w_y(2,1:10)),w_y(3,1:10),fliplr(w_y(4,1:10)),w_y(5,1:10),fliplr(w_y(6,1:10)),w_y(7,1:10),fliplr(w_y(8,1:10)),w_y(9,1:10),fliplr(w_y(10,1:10))]; 
       figure;plot(w_x,w_y,'ro');
        hold on;
        plot(w_x,w_y,'k','linewidth',2);
       % plot(w_x',w_y','k','linewidth',2);
        hold off
        title('input=0');
        drawnow
    case 4
        figure;plot(w_x,w_y,'ro');
        hold on;
        plot(w_x,w_y,'k','linewidth',2);
        plot(w_x',w_y','k','linewidth',2);
        hold off
        title('input=0');
        drawnow
    case 8
        figure;plot(w_x,w_y,'ro');
        hold on;
        plot(w_x,w_y,'k','linewidth',2);
        plot(w_x',w_y','k','linewidth',2);
        for k = 1:17
            if k >10
               xx = [1+mod(k,10):1:10;10:-1:1+mod(k,10)];
            else
                xx = [1:1:k;k:-1:1];
            end
            %% \
            d = 0;
            pt_x = [];
            pt_y = [];
            for j = 1 : size(xx,2)
                d = d+1;
                pt_x(d) = w_x(xx(1,j),xx(2,j));
                pt_y(d) = w_y(xx(1,j),xx(2,j));
            end
            if length(xx) > 1
              hold on; plot(pt_x,pt_y,'k','linewidth',2);
            end
        %% /
            if k >10
               xx = [1+mod(k,10):1:10;10:-1:1+mod(k,10)];
            else
               xx = [1:1:k;k:-1:1];
            end
            d = 0;
            pt_x = [];
            pt_y = [];
            xw = flip(w_x);
            yw = flip(w_y);
            for j = 1 : size(xx,2)
                d = d+1;
                pt_x(d) = xw(xx(1,j),xx(2,j));
                pt_y(d) = yw(xx(1,j),xx(2,j));
            end
            if length(xx) > 1
              hold on; plot(pt_x,pt_y,'k','linewidth',2);
            end 
            
        end
        hold off
        title('input=0');
        drawnow
        
end

%% update weight
t=0;
while (t<N_data)
    t=t+1;
    n=gain*(1-t/N_data);           % update gain,  varied with time
    d=round(region*(1-t/N_data));  % update neughbor nodes,  varied with time
    
        distance=(datax(t)-w_x).^2+(datay(t)-w_y).^2;

        
        if Neighbor == 2
            minx=1;
            min_dis = distance(minx);
            for j1 = 1:100
               if distance(j1)<min_dis
                        min_dis = distance(j1);
                        minx = j1;
               end
            end
            j1star= minx;
            %update the winning neuron        
            w_x(j1star)=w_x(j1star)+n*(datax(t)- w_x(j1star));
            w_y(j1star)=w_y(j1star)+n*(datay(t)- w_y(j1star));
        else    
            minx=1;miny=1;
            min_dis = distance(minx,miny);    
            for j1=1:10
                for j2=1:10
                    if distance(j1,j2)<min_dis
                        min_dis = distance(j1,j2);
                        minx = j1;
                        miny = j2;
                    end
                end
            end
            j1star= minx;
            j2star= miny;
            %update the winning neuron        
            w_x(j1star,j2star)=w_x(j1star,j2star)+n*(datax(t)- w_x(j1star,j2star));
            w_y(j1star,j2star)=w_y(j1star,j2star)+n*(datay(t)- w_y(j1star,j2star));
        end
        %update the neighbour neurons        
        switch Neighbor
          case 8
            for dd=1:1:d
               % 90 Degree
                jj1=j1star-dd;
                jj2=j2star;
                if (jj1>=1)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
                jj1=j1star+dd;
                jj2=j2star;
                if (jj1<=10)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
                jj1=j1star;
                jj2=j2star-dd;
                if (jj2>=1)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
                jj1=j1star;
                jj2=j2star+dd;
                if (jj2<=10)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
              % 45 degree  
                jj1=j1star-dd;
                jj2=j2star-dd;
                if (jj1>=1&&jj2>=1)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
                jj1=j1star+dd;
                jj2=j2star+dd;
                if (jj1<=10&&jj2<=10)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
                jj1=j1star+dd;
                jj2=j2star-dd;
                if (jj1<=10&&jj2>=1)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
                jj1=j1star-dd;
                jj2=j2star+dd;
                if (jj1>=1&&jj2<=10)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end                
            end            
            
            
          case 4
            for dd=1:1:d
                jj1=j1star-dd;
                jj2=j2star;
                if (jj1>=1)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
                jj1=j1star+dd;
                jj2=j2star;
                if (jj1<=10)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
                jj1=j1star;
                jj2=j2star-dd;
                if (jj2>=1)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
                jj1=j1star;
                jj2=j2star+dd;
                if (jj2<=10)
                    w_x(jj1,jj2)=w_x(jj1,jj2)+n*(datax(t)-w_x(jj1,jj2));
                    w_y(jj1,jj2)=w_y(jj1,jj2)+n*(datay(t)-w_y(jj1,jj2));
                end
            end
          case 2  
              for dd=1:1:d
                jj1=j1star-dd;
                if (jj1>=1)
                    w_x(jj1)=w_x(jj1)+n*(datax(t)-w_x(jj1));
                    w_y(jj1)=w_y(jj1)+n*(datay(t)-w_y(jj1));
                end
                jj1=j1star+dd;
                if (jj1<=100)
                    w_x(jj1)=w_x(jj1)+n*(datax(t)-w_x(jj1));
                    w_y(jj1)=w_y(jj1)+n*(datay(t)-w_y(jj1));
                end
              end               
       end
    if t == 25 || t==100 || t==500 || t==1000 || t==5000 || t==N_data
       switch Neighbor
           case 2
                figure;
                plot(datax(1:t),datay(1:t),'.b')
                hold on
                plot(w_x,w_y,'ro');
                plot(w_x,w_y,'k','linewidth',2);
                hold off
                title(['input=' num2str(t)]);
                drawnow
           case 4
                figure;
                plot(datax(1:t),datay(1:t),'.b')
                hold on
                plot(w_x,w_y,'or')
                plot(w_x,w_y,'k','linewidth',2)
                plot(w_x',w_y','k','linewidth',2)
                hold off
                title(['input=' num2str(t)]);
                drawnow  
           case 8
                figure;
                plot(datax(1:t),datay(1:t),'.b')
                hold on
                plot(w_x,w_y,'or')
                plot(w_x,w_y,'k','linewidth',2)
                plot(w_x',w_y','k','linewidth',2)
                for k = 1:17
                    if k >10
                       xx = [1+mod(k,10):1:10;10:-1:1+mod(k,10)];
                    else
                        xx = [1:1:k;k:-1:1];
                    end
                    %% \
                    d = 0;
                    pt_x = [];
                    pt_y = [];
                    for j = 1 : size(xx,2)
                        d = d+1;
                        pt_x(d) = w_x(xx(1,j),xx(2,j));
                        pt_y(d) = w_y(xx(1,j),xx(2,j));
                    end
                    if length(xx) > 1
                      hold on; plot(pt_x,pt_y,'k','linewidth',2);
                    end
                %% /
                    if k >10
                       xx = [1+mod(k,10):1:10;10:-1:1+mod(k,10)];
                    else
                       xx = [1:1:k;k:-1:1];
                    end
                    d = 0;
                    pt_x = [];
                    pt_y = [];
                    xw = flip(w_x);
                    yw = flip(w_y);
                    for j = 1 : size(xx,2)
                        d = d+1;
                        pt_x(d) = xw(xx(1,j),xx(2,j));
                        pt_y(d) = yw(xx(1,j),xx(2,j));
                    end
                    if length(xx) > 1
                      hold on; plot(pt_x,pt_y,'k','linewidth',2);
                    end 

                end
                hold off
                title(['input=' num2str(t)]);
                drawnow                 
       end
    end
end