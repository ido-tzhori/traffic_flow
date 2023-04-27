function vnew=vlag(d,vold)
% This function updates the velocity of a car
% assuming that the velocity obeys the differential equation
% d vel / dt = (v(d) - vel)/tau
% where v(d) is the desired or target velocity, 
% as a function of the distance d to the car ahead.
% The function v(d) is implemented in the file v.m .
% dt is the time step of the simulation, and tau is the time constant
% that governs the approach of the velocity to the desired velocity.
% The above equation is solved by the Backward Euler method, so that
% tau can be arbitrarily small, without any limitation on the time step
% resulting from the smallness of tau.  The backward-Euler method is:
%
% (vnew - vold)/dt = (v(d) - vnew)/tau
%
% which is solved for vnew in the code that follows:
%
  global dt tau;
  vnew = (dt*v(d) + tau*vold) / (dt + tau);
%  
% Note that when tau = 0, vnew = v(d), 
% so the desired velocity is achieved immediately.    
% In general, however, vnew is a weighted average 
% of the old velocity and the desired velocity.
%
% To make use of this function, it is necessary to have the
% velocity of each car stored in an an array, which might
% be called "vel", so that vel(c) is the velocity of car c.
% Then a typical use, once the distance d to the car ahead
% is known for car c, would be the two statements
% vel(c) = vlag(d,vel(c)); 
% p(c) = p(c) + dt*vel(c);
% The first of these statements updates vel(c), and the second one
% uses it to update the position of car c.  
% Note that these can *not* be combined into a single statement, 
% since we need to keep the updated value of vel(c) 
% for use on the next time step.
%
% When this function is used with tau > 0, 
% collisions between cars may occur.  
% These need to be detected by the code, and handled in some way.  
% For example, the cars that collide stay in place for a while,
% and block traffic while they do so.  
% Collision avoidance might also be simulated.
% For example, cars that want to enter the roadway may have to wait
% until such entry would not cause a collision.
%≠≠
% Implementing yellow lights could prevent this from happening.


