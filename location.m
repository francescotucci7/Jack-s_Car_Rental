classdef location
    properties
        lamb_ret = 0;
        lamb_nol = 0;
        max_car = 0;
        earnings;
    end
    
    methods
        function obj = location(lamb_ret,lamb_nol,max_car)
            obj.lamb_ret = lamb_ret;
            obj.lamb_nol = lamb_nol;
            obj.max_car = max_car;
            obj.earnings = 10*(0:max_car);
        end
        

        function Pret = ret_mat(obj)
            Po = (obj.lamb_ret.^(0:obj.max_car))./factorial((0:obj.max_car))*exp(-obj.lamb_ret);
            Pret = zeros(obj.max_car+1);
            for i=1:obj.max_car+1
                Pret(i,1:obj.max_car) = Po(1:obj.max_car);
                Pret(i,obj.max_car+1) = 1 - sum(Po(1:obj.max_car));
                Po = [0,Po(1:obj.max_car)];
            end
        end
        
        function Pnol = nol_mat(obj)
            Po = (obj.lamb_nol.^(0:obj.max_car))./factorial((0:obj.max_car))*exp(-obj.lamb_nol);
            Pnol = zeros(obj.max_car+1);
            for i=obj.max_car+1:-1:1
                Pnol(i,obj.max_car+1:-1:2) = Po(1:obj.max_car);
                Pnol(i,1) = 1 - sum(Po(1:obj.max_car));
                Po = [0,Po(1:obj.max_car)];
            end
        end 
          
        function R = reward_vector(obj)
            Po = (obj.lamb_nol.^(0:obj.max_car))./factorial((0:obj.max_car))*exp(-obj.lamb_nol);
            R = zeros(obj.max_car+1,1);
            for s=obj.max_car+1:-1:1
                R(s) = Po*obj.earnings';
                Po = [Po(1:s-1),zeros(1,obj.max_car-s+2)];
            end
        end
    end
            
     
end
        
           
       
    
