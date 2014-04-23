function ClassNumber = getClassNumber(HDR, ClassName)
    Idx = strcmp(ClassName, HDR.Classnames);
    ClassNumber = find(Idx);
end
