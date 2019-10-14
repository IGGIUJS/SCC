function [ assignment,cost ] = SizeConsAssignIntLinPro( costMat,sizeConsMat,count )
%      options = optimoptions('intlinprog','Display','off','RelativeGapTolerance',0);
%     options = optimoptions('intlinprog','CutGeneration','advanced','RelativeGapTolerance',0,'RootLPMaxIterations',100000,'LPMaxIterations',100000,'Display','iter');
options = optimoptions('intlinprog','CutGeneration','none','RootLPMaxIterations',1000000,'LPMaxIterations',100000,'MaxTime',18000);
% options = optimoptions('intlinprog','CutGeneration','advanced','RelativeGapTolerance',0);
    C=costMat';
%     k=length(sizeConsMat);
    [m,n]=size(C);
    f=C(:);                     %Ŀ�꺯��ϵ������ʵ��Ϊ��������intlinprog�е���֯�����������ܼ��㣩
%     maxDist=max(f);
         %����ϵ��y����Լ������ʽԼ������sizeConsMat����ȡֵ
      extraCoef=zeros(n*n,1);
      for i=1:n
        extraCoef(n*(i-1)+1:i*n)=sizeConsMat;
      end
%     extraCoef=ones(n*n,1);
    f=[extraCoef;f;];            %�ϲ�ԭʼĿ��ϵ�����������ӵ�yϵ�����󣬳�Ϊ����ϵ������
%     intcon=(1:((m*n)+length(extraCoef)))';            %�޶�����X��������Ԫ��Ϊ����
%     intcon=(1:(m*n));
    intcon=(1:length(extraCoef))';
%       intcon=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ڵ�ʽԼ�������Ĺ���˵��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          
% ��Blance-Constraint K-Means�㷨����ѧ��ģ�У��ҵ�ԭʼ�汾�Ľ�ģ���μ�V0.0.18֮ǰ�汾�����ģ�����ʦ�Ĺ��Ĺ�ʽ
%���������ڣ��ҵ�ģ��һ�б�ʾһ��cluster��һ�б�ʾһ��object������ʦ�Ľ�ģ�����෴���������ǰ��ҵĽ�ģд�ģ���
%��ʽԼ��������������ʾX���󣨷������һ������Ԫ����ӣ�ֻ�ܵ���1������ʵ����Ϊ��һ��objectֻ������һ��cluster����
%����200 points��3�࣬��һ�е�1��Ԫ��Ϊ1�����һ������2��Ԫ��ֻ��Ϊ0����point 1�ָ��˵�1�࣬���������������ࣩ��
%�ֶ�Aeq�����������±�Ҫ˵����������������
%   1.��������Aeq����Ϊ��200����200*3�����ľ���ÿһ�б�ʾX�����һ�У�һ��object���ķ������������Ŀ��ϵ������f
%   Ϊһ��600*1����������costMat�е�ÿ��Ԫ�ع��ɵ�����������һ��һ������ÿ��Ԫ�ر�ʾ��ָ���ͬ��Ĵ��ۣ���Aeq������
%   �˴�������û�����⺬�塣
%   2.Aeq�У���1��Ԫ�أ���ʾ��ǰ�����Ϊ�⼸��λ�ã����1������201������401�������������������д���x11��x21��x31
%   λ�õ�Ԫ�أ��⼸��λ�ñ�ʾ�ľ��ǵ�1��object��������ֻ������һ��cluster������������λ�ü�����Ӧ��Ϊ1��������
%   ����A�У�ֻ��һ��Ԫ��Ϊ1������Ϊ0����Aeq1*x11+Aeq2*x21+Aeq3*x31=1�����ܵ�һ�������ֻ��x11Ϊ1������Ϊ0��
%   3.�ڹ���Aeq����ʱ��ͨ����ϸ�۲�����죬������ȡ�ɵĸ�ֵ�������ʹ��eye�ĵ�λ������һ���Ը�ֵ��ֻҪִ��k��
%   ѭ�����ɣ��������ظ���ֵЧ�ʵĽ��ͣ�������Matlab��������д����
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ڵ�ʽԼ�������Ĺ���˵��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Aeq=sparse(m,m*n+n*n);
    Aeq=sparse(m+n*3,m*n+n*n);
%       Aeq=sparse(m+n*3,m*n+n*n);
%     for i=1:n
%         Aeq(1:m,1+(i-1)*m:i*m)=eye(m,m);
%         Aeq(m+1:m+n,m*n+1+(i-1)*n:m*n+n*i)=eye(n);
%         Aeq(m+n+i,m*n+1+(i-1)*n:m*n+n*i)=ones(1,n);
%         Aeq(m+2*n+i,1+(i-1)*m:i*m)=ones(1,m);
%         Aeq(m+2*n+i,m*n+1+(i-1)*n:m*n+n*i)=-1*sizeConsMat;
%     end
for i=1:n
    Aeq(1:m,1+(i-1)*m:i*m)=speye(m,m);
    Aeq(m+1:m+n,m*n+1+(i-1)*n:m*n+n*i)=speye(n);
    Aeq(m+n+i,m*n+1+(i-1)*n:m*n+n*i)=ones(1,n);
    Aeq(m+2*n+i,1+(i-1)*m:i*m)=ones(1,m);
    Aeq(m+2*n+i,m*n+1+(i-1)*n:m*n+n*i)=-1*sizeConsMat;
end
Aeq_test=[Aeq(:,m*n+1:end),Aeq(:,1:m*n)];
% tmp1=zeros(1,(m*n)+length(extraCoef));
% tmp1(1)=1;
% tmp1(64)=1;
% tmp2=zeros(1,(m*n)+length(extraCoef));
% tmp2(1+m)=1;
% tmp2(64+m)=1;
% tmp3=zeros(1,(m*n)+length(extraCoef));
% tmp3(1+m*2)=1;
% tmp3(64+m*2)=1;

% tmp2=zeros(1,(m*n)+length(extraCoef));
% tmp2(1)=1;
% tmp2(3)=1;
% tmp3=zeros(1,(m*n)+length(extraCoef));
% tmp3(1)=1;
% tmp3(3)=1;
% Aeq=[Aeq;tmp1;tmp2;tmp3;];


%     for i=1:n                           %ԭʼ�����к�Ϊ1
%         Aeq(1:m,1+(i-1)*m:i*m)=speye(m,m);
%     end
%     for i=1:n
%         Aeq(m+1:m+n,m*n+1+(i-1)*n:m*n+n*i)=speye(n);
%     end
%     for i=1:n
%         Aeq(m+n+i,m*n+1+(i-1)*n:m*n+n*i)=ones(1,n);
%     end
%     for i=1:n
%         Aeq(m+2*n+i,1+(i-1)*m:i*m)=ones(1,m);
%     end
%     for i=1:n
%         Aeq(m+2*n+i,m*n+1+(i-1)*n:m*n+n*i)=-1*sizeConsMat;
%     end
    %����instance-levelԼ��
%     tmp=zeros(2,m*n+n*n);
%     tmp(1,1:2)=1;
%     tmp(2,3:4)=1;
%     Aeq=[Aeq;tmp];
    beq_1=ones(m+2*n,1);
    beq_2=zeros(n,1);
%     beq_3=[0;0;0];
%     beq_3=[2;1];
    beq=[beq_1;beq_2;];
%     beq=[beq_1;beq_2;beq_3];
%     beq=[beq_1;beq_2;beq_3];
%     beq=ones(m,1);
%     Aeq=sparse(Aeq);
    
    
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ڲ���ʽԼ�������Ĺ���˵��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %
% % %�乹��˼�����ʽԼ������һ�£�����ͨ����������Լ������A������������X������ͬ������ʽԼ����
% % %�ֶ�A����ָ�������Ĵ����е�Լ������A��������������ķ������A��Ϊ��ֹ���壬���ر�˵������Ϊ��Ҫ˵��������������
% % %   1.IntLinProg�������ڲ���ʽԼ����������ֻ����<=������������>=Ҫ��Լ����������ͬʱ����-1��ת��Ϊ<=����ʽ��
% % %   2.min number of cluster<=a1*x11+a2*x12*...an*xnn<= max number of cluster
% % %     ���Ǿ��󹹽�ʹ�õĺ��Ĺ�ʽ�����ԣ���������A����һ��600��Ԫ�أ�ѡȡ���е�200�������һ��ѡ��1-200��������
% % %     �ڶ�Ӧ�ķ�������еģ���һ�У���һ�ࣩ200��points�ķ��������Ҫ�������С��min number of cluster���Ҵ���
% % %     max number of cluster��ͬ��A����ڶ���ѡȡ201-400����Ӧ�����Ƿ�������еĵڶ��У��ڶ��ࣩ���������������
% % %     ���ơ�
% % %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ڲ���ʽԼ�������Ĺ���˵��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     A=zeros(n*2,m*n);
% %     for i=1:n
% %         A(i,1+(i-1)*m:i*m)=ones(1,m)*-1;
% %     end
% %     for i=1:n
% %         A(i+n,1+(i-1)*m:i*m)=ones(1,m);
% %     end
% %     for i=1:n
% %         b(1:n)=sizeConsMat(i)*-1;
% %         b(n+1:n*2)=sizeConsMat(i);
% %     end
%     for i=1:n
%         A(i,1+(i-1)*m:i*m)=ones(1,m)*-1;
%         A(i+n,1+(i-1)*m:i*m)=ones(1,m);
%         b(i)=sizeConsMat(i)*-1;
%         b(n+i)=sizeConsMat(i);
%     end
%     A=sparse(A);

%   ���½��޶�
    lb=zeros(m*n+length(extraCoef),1);        %lb��low bounds���˴��޶�Ϊ0
    ub_1=ones(length(extraCoef),1);
    ub_2=inf(m*n,1);
    ub=[ub_1;ub_2];
%     tmp1=ones(m*n,1)*inf;
%     tmp2=ones(length(extraCoef),1);         %ub��upper bounds���˴��޶�Ϊ1����������intcon�Ѿ��޶�������X����Ϊ�������Ҵ˴����޶�
                            %��X���Ͻ����½磬���Լ�X��ֵֻ��ȡ0��1����0-1�����滮     
%     ub=[tmp1;tmp2;];
%   ִ��0-1�����滮����intlinprog
    A=[];
    b=[];
    [X,cost]=intlinprog(f,intcon,A,b,Aeq_test,beq,lb,ub,options);
%     [X,cost]=intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
%     [X,cost]=linprog(f,A,b,Aeq,beq,lb,ub);
    X=round(X);
%     cost=cost-n*maxDist;
    if(isempty(X))
        count
        mException=MException('Error:AssignmentMatrixEmpty',...
            'There is no solution found of Size Constraint Clustering!');
%         pause; 
        throw(mException);
    else
        X=X(length(extraCoef)+1:end);
        assignment=reshape(X,m,n);
        assignment=assignment';
        
        for j=1:n
            len=length(find(assignment(j,:)==1));
            flag = ismember(len,sizeConsMat);
            if(~flag)
                mException=MException('Error:ElementNotEqual');
                throw(mException);
            end
            locate=find(sizeConsMat(:)==len);
            sizeConsMat(locate(1))=[];
        end
    end
end