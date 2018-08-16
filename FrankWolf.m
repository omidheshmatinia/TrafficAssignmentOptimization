function [LBB, OBJB, x] = FrankWolf(fname)
  % This function solves the static Traffic Assignment Problem of a forward star
  % network using a travel demand file
  % Input:
  %   fname - Name of file, without the extension. For a network called NU, the
  %           forward star file would bu NU.1, and the travel demand NU.2. Then
  %           fname would just be 'NU'
  % Output:
  %   LBB - Lower bound on objective function when finished
  %   OBJB - Objective function value when finished
  %   x - Array of flows on each link in the network
  
  % Reading in Network Demand data
  [no,orgid,startod,nod, dest, od_demand] = read2(strcat(fname,'.2'));
  
  % Reading in FORT data about network
  [nn,frstout,lstout,na,anode,bnode,sat,lngth,vmax] = read1(strcat(fname,'.1'));
  
  % Necessary variables
  k = 1;                         % iteration counter
  epsilon0 = 0.001;              % Acceptable gap amount
  epsilon1 = 1*(10^-4);          % gap criterion
  gap = Inf;                     % initial gap size
  gap_rel = Inf;                 % initial relative gap size
  x = zeros(na,1);               % no flows on any of the 24 links to start with
  K0 = 10000;                    % max number of iterations
  t0 = lngth./vmax;              % free flow travel time
  cost = Problem5TT(x, t0, sat); % Initial link costs
  
  % Setting up buckets for later
  OBJB = zeros(300,1);
  LBB = zeros(300,1);
  
  % Adding another entry to startod so that the for loop can go to the end of
  % destinations
  startod(no+1)=length(dest)+1;

  % Going through all origins
  for i = 1:no
    % Finding the shortest path from the origin to all destinations
    [sP, dist] = bfmsp(nn,frstout,lstout,bnode,i,cost);
    
    for j = startod(i):(startod(i+1)-1)
      
      % Finding the demand for the OD pair i-j
      q_ij = od_demand(j);
      
      % Assigning flow to this all links on the shortest path
      indx = dest(j);
      while indx != i
        x(sP(indx)) += q_ij;
        indx = anode(sP(indx));
      end
    end
  end
  
  % Actual algorithm
  while (gap_rel > epsilon0 && k < K0)
    % Updating y, where y is the solution to the linear subproblem  
    y = zeros(na,1);
    cost = Problem5TT(x, t0, sat);
    
    for i = 1:no
      % Finding the shortest path from the origin to all destinations
      [sP, dist] = bfmsp(nn,frstout,lstout,bnode,i,cost);
    
      % Going through all destinations for origin i
      for j = startod(i):(startod(i+1)-1)
        % Finding the demand for the OD pair i-j
        q_ij = od_demand(j);
      
        % Assigning flow to this all links on the shortest path
        indx = dest(j);
        while indx != i
          y(sP(indx)) += q_ij;
          indx = anode(sP(indx));
        end
      end
    end
    
    % Computing the gap
    gap = sum(cost.*(y.-x));
    
    % Finding the lower bound, 
    low_bound = Problem5UEObj(x, t0, sat) + gap;
    LBB(k) = low_bound/1000;
    OBJB(k) = Problem5UEObj(x, t0, sat)/1000;
    gap_rel = -gap/abs(low_bound);

    % Line Search Time!
    % Initializing necessary values
    I = 0; a=0; b=1; alpha=0.5*(a+b);
    d = y-x; % Descent direction

    % Updating x and t, moving along descent direction with step size alpha
    x_alpha = x + alpha*d;
    t_alpha = Problem5TT(x_alpha, t0, sat);
    s_alpha = sum(t_alpha.*d);

    % bisection search
    while (((I < K0) && ((b-a) > epsilon1) && (abs(s_alpha) > epsilon1)) || (s_alpha > 0))
      % Updating bounds a and b
      if s_alpha < 0
        a = alpha;
      else
        b = alpha;
      end
      % Updating alpha with new boundaries
      alpha = 0.5*(a+b);

      % Updating x, t, and s_alpha for the next iteration
      x_alpha = x + alpha*d;
      t_alpha = Problem5TT(x_alpha, t0, sat);
      s_alpha = sum(t_alpha.*d);

      I++; % updating iteration counter
    end
    % Progressing!
    x = x + alpha*(y-x);
    % Updating t
    t = Problem5TT(x, t0, sat);
    k++; % updating iteration count
  end

  % Outputting important values
  disp 'The objective function value is'
  obj = Problem5UEObj(x, t0, sat)
  disp 'The relative gap is'
  gap_rel
  disp 'The number of iterations is'
  k
end

