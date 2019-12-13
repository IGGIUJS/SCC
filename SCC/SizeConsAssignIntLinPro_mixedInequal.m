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
%       for i=1:n
%         extraCoef(n*(i-1)+1:i*n)=sizeConsMat(1,:);
%       end
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
    Aeq=sparse(m+n*2,m*n+n*n);
for i=1:n
    Aeq(1:m,1+(i-1)*m:i*m)=speye(m,m);
    Aeq(m+1:m+n,m*n+1+(i-1)*n:m*n+n*i)=speye(n);
    Aeq(m+n+i,m*n+1+(i-1)*n:m*n+n*i)=ones(1,n);
%     Aeq(m+2*n+i,1+(i-1)*m:i*m)=ones(1,m);
%     Aeq(m+2*n+i,m*n+1+(i-1)*n:m*n+n*i)=-1*sizeConsMat;
end
Aeq=[Aeq(:,m*n+1:end),Aeq(:,1:m*n)];

    beq=ones(m+2*n,1);
%     beq_2=zeros(n,1);
%     beq=[beq_1;beq_2;];
    
    
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
A = sparse(n*2,m*n+n*n);
for i=1:n
    A(i,1+(i-1)*m:i*m) = -1*ones(1,m);
    A(i,m*n+1+(i-1)*n:m*n+n*i) = sizeConsMat(1,:);
    A(n+i,1+(i-1)*m:i*m) = ones(1,m);
    A(n+i,m*n+1+(i-1)*n:m*n+n*i) = -1*sizeConsMat(2,:);
end
A=[A(:,m*n+1:end),A(:,1:m*n)];
b = zeros(2*n,1);
%   ���½��޶�
    lb=zeros(m*n+length(extraCoef),1);        %lb��low bounds���˴��޶�Ϊ0
    ub_1=ones(length(extraCoef),1);
    ub_2=inf(m*n,1);
    ub=[ub_1;ub_2];
%   ִ��0-1�����滮����intlinprog
    [X,cost]=intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,options);
    X=round(X);
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
        
%         for j=1:n
%             len=length(find(assignment(j,:)==1));
%             flag = ismember(len,sizeConsMat);
%             if(~flag)
%                 mException=MException('Error:ElementNotEqual');
%                 throw(mException);
%             end
%             locate=find(sizeConsMat(:)==len);
%             sizeConsMat(locate(1))=[];
%         end
    end
end