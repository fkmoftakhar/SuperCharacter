#
# SuperCharacter: Computing supercharacter theories of a finite group
#
# Implementations
#
#######################
#######################

#counter := 0;
#partition := [];
#BadParts :=[];
#-----------------------------------------------------------
BindGlobal( "FindBadParts",
function(t, n)
	local BadParts, i,rn,row,cn,sr,col,sc,flag,f,result,c,R,AllFRZ,ConsistantCount,SizeofAllFRZ;
	#Print("Start of finding BadParts...\n\n\n");
	BadParts := [];
	AllFRZ := [];
	for i in [1..n] do
		AllFRZ := Union(AllFRZ,Combinations([2..n],i));	
	od;
	#Print("End of computing AllFRZ.\n");
	rn := 1;
	SizeofAllFRZ:=Size(AllFRZ);
	for rn in [1..SizeofAllFRZ] do
		row :=AllFRZ[rn];
		ConsistantCount := 0;
		sr := Size(row);	
		R:=[];
		for cn in [2..n] do
			col := [];
			Add(col,cn);
			result := 0;
			for c in [1..sr] do
				result := result +Irr(t)[row[c]][1]*Irr(t)[row[c]][col[1]];
			od;
			AddSet(R,result);	
		od;
		if Size(R)=n-1 then
			AddSet(BadParts,row);
		fi;
		#q:=Difference(AllFRZ,BadParts);
	od;
	#Print("End of computing BadParts.\n");	
	#Print(q,"\n\n");
	return BadParts;
end);

#-------------------------------------------------------------------
InstallGlobalFunction( SuperCharacterTheories,
function(ourGroup)
	local CreateKapa, SetPartitions_TreeMode, BadParts, counter, partition,start,t,n,total,second,allseconds,minute,hour,second_Match,c,i;
	
	counter := 0;
	
	CreateKapa := function(irrp, t, n)
		local np,A,si,i,j,k,st,kapa,check,result,flag,st_size;
		np := Size(irrp);
		A := NullMat(np,n);
		for i in [1..np] do
			si := Size(irrp[i]);
			for k in [1..n] do
				result := 0;
				for j in [1..si] do
					result := result + Irr(t)[irrp[i][j]][1]*Irr(t)[irrp[i][j]][k];				
				od;
				A[i][k] := result;
			od;
		od;
		A := TransposedMat(A);
		check := true;
		st := [A[1]];
		kapa := [[1],[2]];
		Add(st,A[2]);
		for i in [3..n] do
			flag := false;
			st_size := Size(st);
			for j in [2..st_size] do
				if A[i]=st[j] then
					Add(kapa[j],i);
					flag := true;
					break;
				fi;
			od;
			if flag=false then
				Add(st,A[i]);
				Add(kapa,[i]);
				if Size(kapa)>Size(st[1]) then
					check := false;
					break;
				fi;
			fi;
		od;	
		if check=true and Size(irrp)=Size(kapa) then
			counter := counter+1;
			Print("\nIrr",counter,"  := ",irrp);
			Print("\nkapa",counter," := ",kapa,"\n");
		fi;
	end;
	
	SetPartitions_TreeMode := function(remainingelement, t, n, partition, BadParts) 
		local code,newremainingelement,nextpart,psize,i,p,k,rx,j;
		if Size(remainingelement)=0  then 
			if Size(partition) < n-1 then
				Add(partition,[1],1);
				CreateKapa(partition, t, n);
				Remove(partition,1);
			fi;
		else
			for code in [1,3..2^Size(remainingelement)-1] do 
				newremainingelement:=[];
				nextpart:=[];
				p:=code; 
				k:=1; 
				while p<>0 do 
					rx:=p mod 2; 
					if rx=1 then 
						Add(nextpart,remainingelement[k]); 
					fi; 
					p:=(p-rx)/2;
					k:=k+1; 
				od;
				if (not (nextpart in BadParts)) then
					newremainingelement := Difference(remainingelement, nextpart);
					psize := Size(partition);
					partition[psize+1]:=nextpart;
					SetPartitions_TreeMode(newremainingelement, t, n, partition, BadParts);
					Remove(partition,psize+1);
				fi;
			od; 
		fi; 
	end;
	
	t := CharacterTableWithSortedCharacters(CharacterTable(ourGroup));
	n := NrConjugacyClasses(t);
	BadParts := FindBadParts(t, n);	
	#Print("\n number of Bad Parts: ",Size(BadParts),"\n");
	c:=0; # TODO: where do we use this?
	for i in [2..n] do
		if [i] in BadParts then
			c := c+1;	
		fi;
	od;

	partition:=[];
	for i in [1..n] do
		Add(partition,[i]);
	od;
	counter := counter+1;
	Print("\nIrr",counter,"  := ",partition);
	Print("\nkapa",counter," := ",partition,"\n");	
	#Print("**************************************************");
	partition:=[];
	SetPartitions_TreeMode([2..n], t, n, partition, BadParts);
end );
