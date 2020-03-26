{В текстовом файле задана матрица смежности графа, представляющего собой дорожную сеть, соединяющую несколько населенных пунктов.

С использованием алгоритма Дейкстры найти кратчайшие расстояния от первого населенного пункта до всех остальных. Вывести маршруты найденных кратчайших путей.}

program grafs;
const
  inf=10000;

type //раздел описания типов данных
  Tabc=array of integer; // объявление динамического массива
  TArry=array of Tabc; 

procedure Reading (var mass:TArry; var n:integer);  //считывает данные о дорогах из файла и сохраняет в массив
var
  f:text; // переменная 
  i,j:byte;
begin
  assign(f, 'roads.txt'); //связывает логический и физический файлы
  reset(f);  // открывает для чтения
  read(f,n);  //n-кол-во точек
  setlength(mass,n); // внутри массива m создаем n ячеек
  for i:=0 to n-1 do
    begin
      setlength(mass[i],n);//длина набора
      for j:=0 to n-1 do
        begin
          read(f, mass[i,j]);
          if mass[i,j]=-1
            then
              mass[i,j]:=inf;
        end;
    end;
end;

procedure Printing(mass:TArry; n:integer); // выводит массив на экран
var
  i,j:byte;
begin
  for i:=0 to n-1 do
    begin
      for j:=0 to n-1 do
        if mass[i,j]=inf
          then
            write('.':4)
          else
            write(mass[i,j]:4);
      writeln;
    end;
end;

procedure AlgDijk(var mass:TArry; n:integer); // алгоритм Дейкстры
var
  a,b,c:Tabc;
  min, ind, itr, i, j, k, v:integer;
begin
  setlength(a,n); // в массиве а создаем n ячеек
  setlength(b,n);
  setlength(c,n);
  writeln('Введите номер начальной вершины (от 1 до 8): ');
  read(k); // номер вершины из которой находим пути ко всем остальным
  for i:=0 to n-1 do  // начало заполнения массивов
    begin
      a[i]:=0;  // отмечает вершины,которые мы уже рассмотрели
      b[i]:=mass[k-1,i]; // сохраняет значение найденного пути(расстояние) 
      c[i]:=k; // сохраняет номер вершины из которой мы пришли
    end;
  a[k-1]:=1; // k-1 потому что индексация в массиве с 0, а номера вершин с 1
  //для того чтобы уравнять разницу берем к-1 и равно 1 потому что пройдена последняя вершина, следовательно алгоритм закончен
  
  // ищем наименьшие пути
  for itr:=1 to n-1 do  //кол-во шагов(повторений)алгоритма
    begin
      min:=inf;
      for i:=0 to n-1 do
        if (min>b[i]) and (a[i]=0)
          then
            begin
              min:=b[i];
              ind:=i;  //индекс наименьшего пути
            end;
      for i:=0 to n-1 do
        if b[i]>b[ind]+mass[i,ind] // если прямой путь длинней чем обходной,тогда 
          then
            begin
              b[i]:=b[ind]+mass[i,ind]; // в значение прямого пути сохраняем значение обходного
              c[i]:=ind+1; //меняем номер точки(пункта)из которой мы пришли (т.к шли обходным путем через другую точку)
            end;
      a[ind]:=1;
    end;
  
  for i:=0 to n-1 do
  begin
    if k<>i+1
      then
        begin
          writeln('Длина кратчайшего пути от пункта ', k, ' до пункта ', i+1, ' равна ', b[i]);
          write('Путь: ');
          v:=i+1;
          write(v:4);
          repeat // цикл с постусловием (повторять пока не ...)
            v:=c[v-1];
            write(v:3);
          until v=k; //условие
          writeln;// вывод
        end;
  end;
end;


var
  mass:TArry;
  n:integer; 
begin // вызов процедур
  Reading(mass,n);//считывает данные о дорогах из файла и сохраняет в массив
  Printing(mass,n);// выводит массив на экран
  AlgDijk(mass,n);// алгоритм Дейкстры
end.
