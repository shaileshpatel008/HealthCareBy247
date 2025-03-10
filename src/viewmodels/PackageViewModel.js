import { useState } from 'react';
import PackageModel from '../models/PackageModel';

const usePackageViewModel = () => {
  const [packages, setPackages] = useState([
    new PackageModel('1', 'ANA PROFILE (IMMUNO BLOT)', 2999, 4500),
    new PackageModel('2', 'TROPONIN-I QUANTITATIVE', 2499, 3200),
    new PackageModel('3', 'A. E. COUNT', 1499, 2000),
    new PackageModel('4', 'Heart Care Package', 3499, 5000),
    new PackageModel('5', 'Advanced Fever Panel', 1499, 2200),
  ]);

  const toggleAddRemove = (id) => {
    setPackages((prevPackages) =>
      prevPackages.map((pkg) =>
        pkg.id === id ? { ...pkg, added: !pkg.added } : pkg
      )
    );
  };

  return { packages, toggleAddRemove };
};

export default usePackageViewModel;