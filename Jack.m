classdef Jack
    properties       
       locA
       locB
       disc
       mCar
       mMove
       cost = 2;
    end
    
    methods
        function obj = Jack(disc,Ar,An,Br,Bn,mCar,mMove)
            obj.mCar = mCar;
            obj.mMove = mMove;
            obj.locA = location(Ar,An,mCar);
            obj.locB = location(Br,Bn,mCar);
            obj.disc = disc;
        end
        
        function P = trans_matrix(obj)
            P = zeros((obj.mCar+1)^2,(obj.mCar+1)^2,2*(obj.mMove)+1);
             
             PAret = obj.locA.ret_mat();
             PBret = obj.locB.ret_mat();
             PAnol = obj.locA.nol_mat();
             PBnol = obj.locB.nol_mat();
             Ps = kron(PBret*PBnol,PAret*PAnol);

            


            Pmove = zeros((obj.mCar+1)^2,(obj.mCar+1)^2,2*(obj.mMove)+1);
            S= size(Ps,1);
            for s=1:S
                [n1, n2] = ind2sub([obj.mCar+1,obj.mCar+1],s);
                n1 = n1-1;
                n2 = n2-1;
                for a=1:2*(obj.mMove)+1
                    move = a-obj.mMove-1;
                    amoved = max(-n2,min(move,n1));
                    New1 = min(n1-amoved,obj.mCar);
                    New2 = min(n2+amoved,obj.mCar);
                    sp = sub2ind([obj.mCar+1 obj.mCar+1], New1+1,New2+1);
                    Pmove(s,sp,a) =1;
                end
            end
            for i = 1:2*(obj.mMove)+1
                P(:,:,i) = Ps*Pmove(:,:,i);
            end 
                
                
        end
        
        
        function R = reward_matrix(obj)
            earnings = zeros(obj.mCar+1,1);
            S = (obj.mCar+1)^2;
            P01 =(obj.locA.lamb_nol.^(0:obj.mCar))./factorial((0:obj.mCar))*exp(-obj.locA.lamb_nol);
            P02 =(obj.locB.lamb_nol.^(0:obj.mCar))./factorial((0:obj.mCar))*exp(-obj.locB.lamb_nol);
            for s = 1:S
                [num1,num2] = ind2sub([obj.mCar+1,obj.mCar+1],s);
                num1 = num1-1;
                num2 = num2-1;
                numAv1= 0:num1;
                numAv2 = 0:num2;
                probRent1 = P01(1:num1+1);
                probRent2 = P02(1:num2+1);
                probRent1(end) = 1 - sum(probRent1(1:end-1));
                probRent2(end) = 1 - sum(probRent2(1:end-1));
                earnings(s) = 10*(sum(numAv1.*probRent1)+sum(numAv2.*probRent2));
                
            end

            PretA = obj.locA.ret_mat();
            PretB = obj.locB.ret_mat();
            Pret = kron(PretB,PretA);
            R = zeros((obj.mCar+1)^2,2*(obj.mMove)+1);
            for a=1:2*(obj.mMove)+1
                R(:,a) = Pret*earnings - obj.cost*abs(a-obj.mMove-1);
            end
        
        
        end
    end
end


