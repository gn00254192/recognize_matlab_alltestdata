for i=1:1:98
      plot(X(i,1),X(i,2),'b+',Y(i,1),Y(i,2),'ro') 
      hold on
      plot([X2b(i,1) Y2(i,1)]',[X2b(i,2) Y2(i,2)]','k-')
end