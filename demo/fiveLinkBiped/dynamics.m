function [dx, dxGrad] = dynamics(t,x,u,p)
% [dx, dxGrad] = dynamics(t,x,u)
%
% Computes the first-order dynamics of the five-link biped, wrapper for
% dynSs.
%
% INPUTS:
%   z = [10,n] = first-order state = [q; dq];
%   u = [5, 1] = input torque vector
%   p = parameter struct

nt = length(t);
empty = zeros(1,nt);  % For vectorization
q = x(1:5,:);
dq = x(6:10,:);
ddq = zeros(size(q));

if nargout == 1   % Using numerical gradients
    [m,mi,f,fi] = autoGen_dynSs(...
        q(1,:),q(2,:),q(3,:),q(4,:),q(5,:),...
        dq(1,:),dq(2,:),dq(3,:),dq(4,:),dq(5,:),...
        u(1,:),u(2,:),u(3,:),u(4,:),u(5,:),...
        p.m1, p.m2, p.m3, p.m4, p.m5, p.I1, p.I2, p.I3, p.I4, p.I5, p.l1, p.l2, p.l3, p.l4, p.c1, p.c2, p.c3, p.c4, p.c5, p.g, empty);
    
    M = zeros(5,5);  %Mass matrix
    F = zeros(5,1);
    for i=1:nt
        M(mi) = m(:,i);
        F(fi) = f(:,i);
        ddq(:,i) = M\F;  %Numerically invert the mass matrix
    end

else  % Using analytic gradients
    [m,mi,f,fi,mz,mzi,mzd,fz,fzi,fzd] = autoGen_dynSs(...
        q(1,:),q(2,:),q(3,:),q(4,:),q(5,:),...
        dq(1,:),dq(2,:),dq(3,:),dq(4,:),dq(5,:),...
        u(1,:),u(2,:),u(3,:),u(4,:),u(5,:),...
        p.m1, p.m2, p.m3, p.m4, p.m5, p.I1, p.I2, p.I3, p.I4, p.I5, p.l1, p.l2, p.l3, p.l4, p.c1, p.c2, p.c3, p.c4, p.c5, p.g, empty);
    
    error('TODO - analytic gradient of dynamics');
    
end

dx = [dq;ddq];

end