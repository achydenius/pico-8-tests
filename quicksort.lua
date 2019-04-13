local function partition(faces, lo, hi)
  local pivot = faces[hi].z
  local i = lo
  for j = lo, hi - 1 do
      if faces[j].z > pivot then
        faces[i], faces[j] = faces[j], faces[i]
        i += 1
      end
  end
  faces[i], faces[hi] = faces[hi], faces[i]
  return i
end

local function quicksort(faces, lo, hi)
  local lo, hi = lo or 1, hi or #faces
  if lo < hi then
    local p = partition(faces, lo, hi)
    quicksort(faces, lo, p - 1)
    quicksort(faces, p + 1, hi)
  end
end

return quicksort
