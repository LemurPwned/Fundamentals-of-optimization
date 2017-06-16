%Params
T=4;
dt=0.001;

A=0.05;
f=2*pi*15;

g=9.81;

m1=400;
m2=50;
k2=200000;
%to optimize
b=2000;
k1=20000;

u2 = -(m1+m2)*g/k2;
u1 = -m1*g/k1+u2;

theta_pos = 0.5;
theta_best = 0.2;
alpha = 0.3;
N = 50;
%k1 - 0: 50000
%b - 0: 5000
xki = 50000.*rand(N,1); %initial position
xbi = 5000.*rand(N,1);
best_known_position = [xki xbi]; %best position
disp('Init pos')
swarm_best_position = [20000 2000];
best_min = abs(-0.2183);
for i=1:N
    k1 = best_known_position(i, 1);
    b = best_known_position(i, 2);
    [Tp, X] = sim('model.mdl');
    current_min = abs(min(X(2,:)));
    if current_min < best_min
        best_min = current_min;
        swarm_best_position = [k1 b];
    end      
    c1 = 50000;
    c2 = 5000;
    v(i, 1) = 2*c1*rand(1,1) - c1;
    v(i, 2) = 2*c2*rand(1,1) - c2;
end

error = 10;
I = 0;
while error > 1e-3 && I < 50
    I = I + 1
    for i=1:N
        r = rand(2, 1);
        v(i,1) = alpha*v(i,1) + theta_pos*r(1)*...
            (best_known_position(i,1) - xki(i)) + ...
            theta_best*r(2)*(swarm_best_position(1) - xki(i,1));
        v(i,2) = alpha*v(i,2) + theta_pos*r(1)*...
            (best_known_position(i,1) - xbi(i)) + ...
            theta_best*r(2)*(swarm_best_position(2) - xbi(i));
        xki(i) = xki(i) + v(i,1);
        xbi(i) = xbi(i) + v(i,2);
        b = xbi(i);
        k1 = xki(i);        
        [Tp, X] = sim('model.mdl');
        current_min = abs(min(X(2,:)));
        k1 = best_known_position(i, 1);
        b = best_known_position(i, 2);
        [Tp, X] = sim('model.mdl');
        current_best = abs(min(X(2,:)));
        if current_min < current_best
            best_known_position(i,1) = xki(i);
            best_known_position(i,2) = xbi(i);
            if current_min < best_min
                best_min = current_min;
                swarm_best_position = [xki(i) xbi(i)];
            end
        end
    end
end


min(x1)
disp('End')

