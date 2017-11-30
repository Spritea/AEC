function CloseMatlabPool_fun
%====================================================================
%关闭 MATLAB 并行运算，与 StartMatlabPool_fun() 函数配合使用（ling）
%StartMatlabPool(size)
   poolobj = gcp('nocreate');
   delete(poolobj);
end