
cd "D:\Datasets\US Census\jt_laws\"

use "D:\Datasets\US Census\clay_laws\state_age_limits_1880_1930_17oct2016.dta" , clear


save "D:\Datasets\US Census\jt_laws\state_age_limits_1850_1930_07may2025_JT.dta", replace

* extend time series until 1850

****************************************************
* 1) Load your original data
****************************************************
use "D:\Datasets\US Census\clay_laws\state_age_limits_1880_1930_17oct2016.dta", clear

****************************************************
* 0) Backup original data
****************************************************
tempfile orig
save `orig', replace

****************************************************
* 1) Extract distinct states
****************************************************
use `orig', clear
keep statename statefip
duplicates drop
tempfile states
save `states'

****************************************************
* 2) Build two "years" tables:
*    • 1830–1879 (50 obs)
*    • 1931–1963 (33 obs)
*    then stack them into one
****************************************************
* 2a) 1850–1879
tempfile years1
clear
set obs 50
gen year = 1830 + _n - 1
save `years1'

* 2b) 1931–1950
tempfile years2
clear
set obs 33
gen year = 1931 + _n - 1
save `years2'

* 2c) Combine into one "years" file
tempfile years
use `years1', clear
append using `years2'
save `years'

****************************************************
* 3) Cross‐join states × all years
****************************************************
use `states', clear
cross using `years'
tempfile panel_years
save `panel_years'

****************************************************
* 4) Append to original and zero‐fill missing
****************************************************
use `orig', clear
append using `panel_years'

* zero‐out all numeric data vars where missing
foreach var of varlist entryage exitage earlyyrs /// 
    earlyyrs_condition workage workyrs contage contyrs {
    replace `var' = 0 if missing(`var')
}

* blank out all string data vars where missing
foreach var of varlist reference_agelimit reference_courseofstudy {
    replace `var' = "" if missing(`var')
}

****************************************************
* 5) Sort & save final dataset
****************************************************
sort statename year
save "D:\Datasets\US Census\jt_laws\state_age_limits_1850_1930_13may2025_JT.dta", replace


use "D:\Datasets\US Census\jt_laws\state_age_limits_1850_1930_13may2025_JT.dta", clear

* Handcode laws -  extend back to 1850

* Create a weeks variable
gen weeks = .

** Arizona 1875 (extension)

replace entryage = 8 if statefip == 4 & year == 1879 | statefip == 4 & year == 1878 | statefip == 4 & year == 1877 | statefip == 4 & year == 1876 | statefip == 4 & year == 1875

replace exitage = 14 if statefip == 4 & year == 1879 | statefip == 4 & year == 1878 | statefip == 4 & year == 1877 | statefip == 4 & year == 1876 | statefip == 4 & year == 1875

replace earlyyrs = 998 if statefip == 4 & year == 1879 | statefip == 4 & year == 1878 | statefip == 4 & year == 1877 | statefip == 4 & year == 1876 | statefip == 4 & year == 1875

** California 1874

replace entryage = 8 if statefip == 6 & year == 1879 | statefip == 6 & year == 1878 | statefip == 6 & year == 1877 | statefip == 6 & year == 1876 | statefip == 6 & year == 1875 | statefip == 6 & year == 1874

replace exitage = 14 if statefip == 6 & year == 1879 | statefip == 6 & year == 1878 | statefip == 6 & year == 1877 | statefip == 6 & year == 1876 | statefip == 6 & year == 1875 | statefip == 6 & year == 1874

replace earlyyrs = 998 if statefip == 6 & year == 1879 | statefip == 6 & year == 1878 | statefip == 6 & year == 1877 | statefip == 6 & year == 1876 | statefip == 6 & year == 1875 | statefip == 6 & year == 1874

** Connecticut 1872 - Connecticut had some compulsory schooling provisions for children who worked before but this was the first universal law

replace entryage = 8 if statefip == 9 & year == 1879 | statefip == 9 & year == 1878 | statefip == 9 & year == 1877 | statefip == 9 & year == 1876 | statefip == 9 & year == 1875 | statefip == 9 & year == 1874 | statefip == 9 & year == 1873 | statefip == 9 & year == 1872

replace exitage = 14 if statefip == 9 & year == 1879 | statefip == 9 & year == 1878 | statefip == 9 & year == 1877 | statefip == 9 & year == 1876 | statefip == 9 & year == 1875 | statefip == 9 & year == 1874 | statefip == 9 & year == 1873 | statefip == 9 & year == 1872

** District of Columbia 1864

replace entryage = 8 if statefip == 11 & year == 1879 | statefip == 11 & year == 1878 | statefip == 11 & year == 1877 | statefip == 11 & year == 1876 | statefip == 11 & year == 1875 | statefip == 11 & year == 1874 | statefip == 11 & year == 1873 | statefip == 11 & year == 1872 | statefip == 11 & year == 1871 | statefip == 11 & year == 1870 | statefip == 11 & year == 1869 | statefip == 11 & year == 1868 | statefip == 11 & year == 1867 | statefip == 11 & year == 1866 | statefip == 11 & year == 1865 | statefip == 11 & year == 1864

replace exitage = 14 if statefip == 11 & year == 1879 | statefip == 11 & year == 1878 | statefip == 11 & year == 1877 | statefip == 11 & year == 1876 | statefip == 11 & year == 1875 | statefip == 11 & year == 1874 | statefip == 11 & year == 1873 | statefip == 11 & year == 1872 | statefip == 11 & year == 1871 | statefip == 11 & year == 1870 | statefip == 11 & year == 1869 | statefip == 11 & year == 1868 | statefip == 11 & year == 1867 | statefip == 11 & year == 1866 | statefip == 11 & year == 1865 | statefip == 11 & year == 1864

** Kansas 1874

replace entryage = 8 if statefip == 20 & year == 1879 | statefip == 20 & year == 1878 | statefip == 20 & year == 1877 | statefip == 20 & year == 1876 | statefip == 20 & year == 1875 | statefip == 20 & year == 1874

replace exitage = 14 if statefip == 20 & year == 1879 | statefip == 20 & year == 1878 | statefip == 20 & year == 1877 | statefip == 20 & year == 1876 | statefip == 20 & year == 1875 | statefip == 20 & year == 1874

replace earlyyrs = 998 if statefip == 20 & year == 1879 | statefip == 20 & year == 1878 | statefip == 20 & year == 1877 | statefip == 20 & year == 1876 | statefip == 20 & year == 1875 | statefip == 20 & year == 1874

** Maine 1875

replace entryage = 9 if statefip == 23 & year == 1879 | statefip == 23 & year == 1878 | statefip == 23 & year == 1877 | statefip == 23 & year == 1876 | statefip == 23 & year == 1875 

replace exitage = 15 if statefip == 23 & year == 1879 | statefip == 23 & year == 1878 | statefip == 23 & year == 1877 | statefip == 23 & year == 1876 | statefip == 23 & year == 1875 

** Massachusetts 1852, 1873, 1874

replace entryage = 8 if statefip == 25 & year == 1879 | statefip == 25 & year == 1878 | statefip == 25 & year == 1877 | statefip == 25 & year == 1876 | statefip == 25 & year == 1875 | statefip == 25 & year == 1874 | statefip == 25 & year == 1873 | statefip == 25 & year == 1872 | statefip == 25 & year == 1871 | statefip == 25 & year == 1870 | statefip == 25 & year == 1869 | statefip == 25 & year == 1868 | statefip == 25 & year == 1867 | statefip == 25 & year == 1866 | statefip == 25 & year == 1865 | statefip == 25 & year == 1864 | statefip == 25 & year == 1863 | statefip == 25 & year == 1862 | statefip == 25 & year == 1861 | statefip == 25 & year == 1860 | statefip == 25 & year == 1859 | statefip == 25 & year == 1858 | statefip == 25 & year == 1857 | statefip == 25 & year == 1856 | statefip == 25 & year == 1855 | statefip == 25 & year == 1854 | statefip == 25 & year == 1853 | statefip == 25 & year == 1852  

replace exitage = 14 if statefip == 25 & year == 1879 | statefip == 25 & year == 1878 | statefip == 25 & year == 1877 | statefip == 25 & year == 1876 | statefip == 25 & year == 1875 | statefip == 25 & year == 1874 | statefip == 25 & year == 1872 | statefip == 25 & year == 1871 | statefip == 25 & year == 1870 | statefip == 25 & year == 1869 | statefip == 25 & year == 1868 | statefip == 25 & year == 1867 | statefip == 25 & year == 1866 | statefip == 25 & year == 1865 | statefip == 25 & year == 1864 | statefip == 25 & year == 1863 | statefip == 25 & year == 1862 | statefip == 25 & year == 1861 | statefip == 25 & year == 1860 | statefip == 25 & year == 1859 | statefip == 25 & year == 1858 | statefip == 25 & year == 1857 | statefip == 25 & year == 1856 | statefip == 25 & year == 1855 | statefip == 25 & year == 1854 | statefip == 25 & year == 1853 | statefip == 25 & year == 1852  

replace exitage = 12 if statefip == 25 & year == 1873

replace earlyyrs = 998 if statefip == 25 & year == 1879 | statefip == 25 & year == 1878 | statefip == 25 & year == 1877 | statefip == 25 & year == 1876 | statefip == 25 & year == 1875 | statefip == 25 & year == 1874 | statefip == 25 & year == 1872 | statefip == 25 & year == 1871 | statefip == 25 & year == 1870 | statefip == 25 & year == 1869 | statefip == 25 & year == 1868 | statefip == 25 & year == 1867 | statefip == 25 & year == 1866 | statefip == 25 & year == 1865 | statefip == 25 & year == 1864 | statefip == 25 & year == 1863 | statefip == 25 & year == 1862 | statefip == 25 & year == 1861 | statefip == 25 & year == 1860 | statefip == 25 & year == 1859 | statefip == 25 & year == 1858 | statefip == 25 & year == 1857 | statefip == 25 & year == 1856 | statefip == 25 & year == 1855 | statefip == 25 & year == 1854 | statefip == 25 & year == 1853 | statefip == 25 & year == 1852  

replace earlyyrs = 996 if statefip == 25 & year == 1873 

** Michigan 1871

replace entryage = 8 if statefip == 26 & year == 1879 | statefip == 26 & year == 1878 | statefip == 26 & year == 1877 | statefip == 26 & year == 1876 | statefip == 26 & year == 1875 | statefip == 26 & year == 1874 | statefip == 26 & year == 1873 | statefip == 26 & year == 1872 | statefip == 26 & year == 1871 

replace entryage = 8 if statefip == 26 & year == 1881 | statefip == 26 & year == 1882 

replace exitage = 14 if statefip == 26 & year == 1879 | statefip == 26 & year == 1878 | statefip == 26 & year == 1877 | statefip == 26 & year == 1876 | statefip == 26 & year == 1875 | statefip == 26 & year == 1874 | statefip == 26 & year == 1873 | statefip == 26 & year == 1872 | statefip == 26 & year == 1871 

replace exitage = 14 if statefip == 26 & year == 1881 | statefip == 26 & year == 1882 

replace earlyyrs = 998 if statefip == 26 & year == 1881 | statefip == 26 & year == 1882 | statefip == 26 & year == 1879 | statefip == 26 & year == 1878 | statefip == 26 & year == 1877 | statefip == 26 & year == 1876 | statefip == 26 & year == 1875 | statefip == 26 & year == 1874 | statefip == 26 & year == 1873 | statefip == 26 & year == 1872 | statefip == 26 & year == 1871 

** Nevada 1873

replace entryage = 8 if statefip == 32 & year == 1879 | statefip == 32 & year == 1878 | statefip == 32 & year == 1877 | statefip == 32 & year == 1876 | statefip == 32 & year == 1875 | statefip == 32 & year == 1874 | statefip == 32 & year == 1873 

replace exitage = 14 if statefip == 32 & year == 1879 | statefip == 32 & year == 1878 | statefip == 32 & year == 1877 | statefip == 32 & year == 1876 | statefip == 32 & year == 1875 | statefip == 32 & year == 1874 | statefip == 32 & year == 1873 

replace earlyyrs = 998 if statefip == 32 & year == 1879 | statefip == 32 & year == 1878 | statefip == 32 & year == 1877 | statefip == 32 & year == 1876 | statefip == 32 & year == 1875 | statefip == 32 & year == 1874 | statefip == 32 & year == 1873 

replace weeks = 16 if statefip == 32 & year < 1908

** New Hampshire 1871

replace entryage = 8 if statefip == 33 & year == 1879 | statefip == 33 & year == 1878 | statefip == 33 & year == 1877 | statefip == 33 & year == 1876 | statefip == 33 & year == 1875 | statefip == 33 & year == 1874 | statefip == 33 & year == 1873 | statefip == 33 & year == 1872 | statefip == 33 & year == 1871 

replace exitage = 14 if statefip == 33 & year == 1879 | statefip == 33 & year == 1878 | statefip == 33 & year == 1877 | statefip == 33 & year == 1876 | statefip == 33 & year == 1875 | statefip == 33 & year == 1874 | statefip == 33 & year == 1873 | statefip == 33 & year == 1872 | statefip == 33 & year == 1871 

replace weeks = 12 if statefip == 33 & year < 1880 & year > 1870

** New Jersey 1875

replace entryage = 8 if statefip == 34 & year == 1879 | statefip == 34 & year == 1878 | statefip == 34 & year == 1877 | statefip == 34 & year == 1876 | statefip == 34 & year == 1875 

replace exitage = 14 if statefip == 34 & year == 1879 | statefip == 34 & year == 1878 | statefip == 34 & year == 1877 | statefip == 34 & year == 1876 | statefip == 34 & year == 1875 

replace weeks = 12 if statefip == 34 & year >= 1875 & year < 1885
replace weeks = 20 if statefip == 34 & year >= 1885 & year < 1903
replace weeks = 52 if statefip == 34 & year >= 1903

** New York 1874

replace entryage = 8 if statefip == 36 & year == 1879 | statefip == 36 & year == 1878 | statefip == 36 & year == 1877 | statefip == 36 & year == 1876 | statefip == 36 & year == 1875 | statefip == 36 & year == 1874 

replace entryage = 7 if statefip == 36 & year >= 1909 

replace exitage = 14 if statefip == 36 & year == 1879 | statefip == 36 & year == 1878 | statefip == 36 & year == 1877 | statefip == 36 & year == 1876 | statefip == 36 & year == 1875 | statefip == 36 & year == 1874 

replace weeks = 14 if statefip == 36 & year >= 1874 & year < 1894
replace weeks = 52 if statefip == 36 & year >= 1894

** Ohio 1877

replace entryage = 8 if statefip == 39 & year == 1879 | statefip == 39 & year == 1878 | statefip == 39 & year == 1877

replace exitage = 14 if statefip == 39 & year == 1879 | statefip == 39 & year == 1878 | statefip == 39 & year == 1877

replace weeks = 12 if statefip == 39 & year >= 1877 & year < 1889
replace weeks = 20 if statefip == 39 & year >= 1889 & year < 1890 // 16 for townships
replace weeks = 52 if statefip == 39 & year >= 1890

** Vermont 1867

replace entryage = 8 if statefip == 50 & year == 1879 | statefip == 50 & year == 1878 | statefip == 50 & year == 1877 | statefip == 50 & year == 1876 | statefip == 50 & year == 1875 | statefip == 50 & year == 1874 | statefip == 50 & year == 1873 | statefip == 50 & year == 1872 | statefip == 50 & year == 1871 | statefip == 50 & year == 1870 | statefip == 50 & year == 1869 | statefip == 50 & year == 1868 | statefip == 50 & year == 1867 

replace exitage = 14 if statefip == 50 & year == 1879 | statefip == 50 & year == 1878 | statefip == 50 & year == 1877 | statefip == 50 & year == 1876 | statefip == 50 & year == 1875 | statefip == 50 & year == 1874 | statefip == 50 & year == 1873 | statefip == 50 & year == 1872 | statefip == 50 & year == 1871 | statefip == 50 & year == 1870 | statefip == 50 & year == 1869 | statefip == 50 & year == 1868 | statefip == 50 & year == 1867 

replace earlyyrs = 9 if statefip == 50 & year == 1879 | statefip == 50 & year == 1878 | statefip == 50 & year == 1877 | statefip == 50 & year == 1876 | statefip == 50 & year == 1875 | statefip == 50 & year == 1874 | statefip == 50 & year == 1873 | statefip == 50 & year == 1872 | statefip == 50 & year == 1871 | statefip == 50 & year == 1870 | statefip == 50 & year == 1869 | statefip == 50 & year == 1868 | statefip == 50 & year == 1867 

replace weeks = 12 if statefip == 50 & year >= 1867 & year < 1889
replace weeks = 20 if statefip == 50 & year >= 1889 & year < 1894
replace weeks = 26 if statefip == 50 & year >= 1894 & year < 1915
replace weeks = 52 if statefip == 50 & year >= 1915 

** Wisconsin 1879

replace entryage = 7 if statefip == 55 & year == 1879

replace exitage = 15 if statefip == 55 & year == 1879

replace earlyyrs = 998 if statefip == 55 & year == 1879

replace weeks = 12 if statefip == 55 & year >= 1879 & year < 1889
replace weeks = 24 if statefip == 55 & year >= 1889 & year < 1903 // depending on the district between 12-24 weeks
replace weeks = 52 if statefip == 55 & year >= 1903

** Wyoming 1873

replace entryage = 7 if statefip == 56 & year == 1879 | statefip == 56 & year == 1878 | statefip == 56 & year == 1877 | statefip == 56 & year == 1876 | statefip == 56 & year == 1875 | statefip == 56 & year == 1874 | statefip == 56 & year == 1873 

replace exitage = 16 if statefip == 56 & year == 1879 | statefip == 56 & year == 1878 | statefip == 56 & year == 1877 | statefip == 56 & year == 1876 | statefip == 56 & year == 1875 | statefip == 56 & year == 1874 | statefip == 56 & year == 1873 

replace exitage = 14 if statefip == 56 & year == 1907 | statefip == 56 & year == 1908 | statefip == 56 & year == 1909 | statefip == 56 & year == 1910 | statefip == 56 & year == 1911 | statefip == 56 & year == 1912 | statefip == 56 & year == 1913 | statefip == 56 & year == 1914 | statefip == 56 & year == 1915 | statefip == 56 & year == 1916 | statefip == 56 & year == 1917 | statefip == 56 & year == 1918 | statefip == 56 & year == 1919 | statefip == 56 & year == 1920 | statefip == 56 & year == 1921 | statefip == 56 & year == 1922 | statefip == 56 & year == 1923

replace exitage = 16 if statefip == 56 & year == 1923 | statefip == 56 & year == 1924 | statefip == 56 & year == 1925 | statefip == 56 & year == 1926 | statefip == 56 & year == 1927 | statefip == 56 & year == 1928 | statefip == 56 & year == 1929 | statefip == 56 & year == 1930 

replace weeks = 0 if statefip == 56 & year >= 1873 & year < 1907
replace weeks = 26 if statefip == 56 & year >= 1907 & year < 1909 // half the school year 
replace weeks = 52 if statefip == 56 & year >= 1909

* Now -  extend forward to 1950

** Alabama
replace entryage = 7 if statefip == 1 & year >= 1931

replace exitage = 16 if statefip == 1 & year >= 1931

replace earlyyrs = 8 if statefip == 1 & year >= 1931

replace earlyyrs_condition = 14 if statefip == 1 & year >= 1931

replace workage = 14 if statefip == 1 & year >= 1931

replace workyrs = 6 if statefip == 1 & year >= 1931

replace weeks = 16 if statefip == 1 & year >= 1917 & year < 1919
replace weeks = 52 if statefip == 1 & year >= 1919
 
** Arizona

replace entryage = 8 if statefip == 4 & year >= 1931

replace exitage = 16 if statefip == 4 & year >= 1931

replace earlyyrs = 998 if statefip == 4 & year >= 1931

replace workage = 14 if statefip == 4 & year >= 1931

replace workyrs = 5 if statefip == 4 & year >= 1931

replace contage = 16 if statefip == 4 & year >= 1931

replace weeks = 12 if statefip == 4 & year >= 1899 & year < 1907
replace weeks = 26 if statefip == 4 & year >= 1907 & year < 1912
replace weeks = 52 if statefip == 4 & year >= 1913

** Arkansas
replace entryage = 7 if statefip == 5 & year >= 1917

replace exitage = 15 if statefip == 5 & year >= 1917

replace earlyyrs = 7 if statefip == 5 & year >= 1917

** California
replace entryage = 8 if statefip == 6 & year >= 1931

replace exitage = 16 if statefip == 6 & year >= 1931

replace workage = 15 if statefip == 6 & year >= 1931

replace workyrs = 7 if statefip == 6 & year >= 1931

replace contage = 18 if statefip == 6 & year >= 1931

replace contyrs = 12 if statefip == 6 & year >= 1931

** Colorado
replace entryage = 8 if statefip == 8 & year >= 1931

replace exitage = 16 if statefip == 8 & year >= 1931

replace earlyyrs = 8 if statefip == 8 & year >= 1931

replace earlyyrs_condition = 14 if statefip == 8 & year >= 1931

replace contage = 16 if statefip == 8 & year >= 1931

replace contyrs = 99 if statefip == 8 & year >= 1931

** Connecticut - no changes?
replace entryage = 7 if statefip == 9 & year >= 1931

replace exitage = 16 if statefip == 9 & year >= 1931

replace workage = 14 if statefip == 9 & year >= 1931

replace workyrs = 6 if statefip == 9 & year >= 1931

replace contage = 16 if statefip == 9 & year >= 1931

replace contyrs = 8 if statefip == 9 & year >= 1931

** Delaware - no changes?
replace entryage = 7 if statefip == 10 & year >= 1931

replace exitage = 17 if statefip == 10 & year >= 1931

replace earlyyrs = 8 if statefip == 10 & year >= 1931

replace workage = 14 if statefip == 10 & year >= 1931

replace workyrs = 5 if statefip == 10 & year >= 1931

replace contage = 16 if statefip == 10 & year >= 1931

** District of Columbia - no changes?
replace entryage = 7 if statefip == 11 & year >= 1931

replace exitage = 16 if statefip == 11 & year >= 1931

replace workage = 14 if statefip == 11 & year >= 1931

replace workyrs = 8 if statefip == 11 & year >= 1931

** Florida
replace entryage = 7 if statefip == 12 & year >= 1931

replace exitage = 16 if statefip == 12 & year >= 1931

replace earlyyrs = 8 if statefip == 12 & year >= 1931

replace workage = 14 if statefip == 12 & year >= 1931

replace workyrs = 99 if statefip == 12 & year >= 1931

replace contage = 16 if statefip == 12 & year >= 1931

replace contyrs = 8 if statefip == 12 & year >= 1931

** Georgia
replace entryage = 8 if statefip == 13 & year >= 1931 & year < 1945
replace entryage = 7 if statefip == 13 & year >= 1945 

replace exitage = 14 if statefip == 13 & year >= 1931 & year < 1945
replace exitage = 16 if statefip == 13 & year >= 1945

replace earlyyrs = 7 if statefip == 13 & year >= 1931

** Idaho - no changes?
replace entryage = 8 if statefip == 16 & year >= 1931

replace exitage = 18 if statefip == 16 & year >= 1931

replace earlyyrs = 8 if statefip == 16 & year >= 1931

replace earlyyrs_condition = 15 if statefip == 16 & year >= 1931

** Illinois
replace entryage = 7 if statefip == 17 & year >= 1931

replace exitage = 16 if statefip == 17 & year >= 1931

replace workage = 14 if statefip == 17 & year >= 1931

replace workyrs = 8 if statefip == 17 & year >= 1931

replace contage = 18 if statefip == 17 & year >= 1931

replace contyrs = 12 if statefip == 17 & year >= 1931

** Indiana
replace entryage = 7 if statefip == 18 & year >= 1931

replace exitage = 16 if statefip == 18 & year >= 1931

replace workage = 14 if statefip == 18 & year >= 1931

replace workyrs = 8 if statefip == 18 & year >= 1931

replace contage = 18 if statefip == 18 & year >= 1931

** Iowa
replace entryage = 7 if statefip == 19 & year >= 1931

replace exitage = 16 if statefip == 19 & year >= 1931

replace earlyyrs = 8 if statefip == 19 & year >= 1931

replace workage = 14 if statefip == 19 & year >= 1931

replace workyrs = 6 if statefip == 19 & year >= 1931

replace contage = 16 if statefip == 19 & year >= 1931

replace contyrs = 8 if statefip == 19 & year >= 1931

** Kansas
replace entryage = 7 if statefip == 20 & year >= 1931

replace exitage = 16 if statefip == 20 & year >= 1931

replace earlyyrs = 8 if statefip == 20 & year >= 1931

** Kentucky
replace entryage = 7 if statefip == 21 & year >= 1931

replace exitage = 16 if statefip == 21 & year >= 1931

replace earlyyrs = 8 if statefip == 21 & year >= 1931

replace workage = 14 if statefip == 21 & year >= 1931

replace workyrs = 5 if statefip == 21 & year >= 1931

replace contage = 16 if statefip == 21 & year >= 1931

replace contyrs = 8 if statefip == 21 & year >= 1931

** Lousiana
replace entryage = 8 if statefip == 22 & year >= 1914 & year < 1916
replace entryage = 7 if statefip == 22 & year >= 1916

replace exitage = 14 if statefip == 22 & year >= 1914

replace earlyyrs = 998 if statefip == 22 & year >= 1931

** Maine
replace entryage = 7 if statefip == 23 & year >= 1931

replace exitage = 17 if statefip == 23 & year >= 1931

replace earlyyrs = 8 if statefip == 23 & year >= 1931

replace earlyyrs_condition = 15 if statefip == 23 & year >= 1931

replace contage = 18 if statefip == 23 & year >= 1931

replace contyrs = 9910 if statefip == 23 & year >= 1931

** Maryland
replace entryage = 7 if statefip == 24 & year >= 1931

replace exitage = 17 if statefip == 24 & year >= 1931

replace earlyyrs = 997 if statefip == 24 & year >= 1931

replace earlyyrs_condition = 15 if statefip == 24 & year >= 1931

replace workage = 15 if statefip == 24 & year >= 1931

replace workyrs = 997 if statefip == 24 & year >= 1931

** Massachusetts
replace entryage = 7 if statefip == 25 & year >= 1931

replace exitage = 16 if statefip == 25 & year >= 1931

replace earlyyrs = 6 if statefip == 25 & year >= 1931

replace earlyyrs_condition = 14 if statefip == 25 & year >= 1931

replace workage = 14 if statefip == 25 & year >= 1931

replace workyrs = 6 if statefip == 25 & year >= 1931

replace contage = 16 if statefip == 25 & year >= 1931

** Michigan
replace entryage = 7 if statefip == 26 & year >= 1931 & year < 1944
replace entryage = 6 if statefip == 26 & year >= 1944

replace exitage = 16 if statefip == 26 & year >= 1931

replace earlyyrs = 8 if statefip == 26 & year >= 1931

replace contage = 17 if statefip == 26 & year >= 1931

replace contyrs = 10 if statefip == 26 & year >= 1931

** Minnesota
replace entryage = 8 if statefip == 27 & year >= 1931

replace exitage = 16 if statefip == 27 & year >= 1931

replace earlyyrs = 8 if statefip == 27 & year >= 1931

** Missisipi
replace entryage = 7 if statefip == 28 & year >= 1918

replace exitage = 14 if statefip == 28 & year >= 1918 & year < 1924
replace exitage = 16 if statefip == 28 & year >= 1924

replace earlyyrs = 998 if statefip == 28 & year >= 1918

** Missouri
replace entryage = 7 if statefip == 29 & year >= 1931

replace exitage = 16 if statefip == 29 & year >= 1931

replace earlyyrs = 998 if statefip == 29 & year >= 1931

replace workage = 14 if statefip == 29 & year >= 1931

replace workyrs = 6 if statefip == 29 & year >= 1931

replace contage = 16 if statefip == 29 & year >= 1931

** Montana
replace entryage = 8 if statefip == 30 & year >= 1931

replace exitage = 16 if statefip == 30 & year >= 1931

replace workage = 14 if statefip == 30 & year >= 1931

replace workyrs = 8 if statefip == 30 & year >= 1931

replace contage = 18 if statefip == 30 & year >= 1931

replace contyrs = 12 if statefip == 30 & year >= 1931

** Nebraska
replace entryage = 7 if statefip == 31 & year >= 1931

replace exitage = 16 if statefip == 31 & year >= 1931

replace earlyyrs = 12 if statefip == 31 & year >= 1931

replace contage = 16 if statefip == 31 & year >= 1931

replace contyrs = 12 if statefip == 31 & year >= 1931

** Nevada - no changes??
replace entryage = 7 if statefip == 32 & year >= 1931

replace exitage = 18 if statefip == 32 & year >= 1931

replace earlyyrs = 12 if statefip == 32 & year >= 1931

replace workage = 14 if statefip == 32 & year >= 1931

replace workyrs = 8 if statefip == 32 & year >= 1931

replace contage = 18 if statefip == 32 & year >= 1931

replace contyrs = 8 if statefip == 32 & year >= 1931

** New Hampshire - no changes??
replace entryage = 8 if statefip == 33 & year >= 1931

replace exitage = 16 if statefip == 33 & year >= 1931

replace earlyyrs = 998 if statefip == 33 & year >= 1931

replace earlyyrs_condition = 14 if statefip == 33 & year >= 1931

** New Jersey
replace entryage = 7 if statefip == 34 & year >= 1931

replace exitage = 16 if statefip == 34 & year >= 1931

replace workage = 14 if statefip == 34 & year >= 1931

replace workyrs = 6 if statefip == 34 & year >= 1931

replace contage = 16 if statefip == 34 & year >= 1931

** New Mexico -- no changes?
replace entryage = 6 if statefip == 35 & year >= 1931

replace exitage = 17 if statefip == 35 & year >= 1931

replace workage = 16 if statefip == 35 & year >= 1931

replace contage = 16 if statefip == 35 & year >= 1931

** New York
replace entryage = 7 if statefip == 36 & year >= 1931

replace exitage = 16 if statefip == 36 & year >= 1931

replace workage = 14 if statefip == 36 & year >= 1931

replace workyrs = 8 if statefip == 36 & year >= 1931

replace contage = 17 if statefip == 36 & year >= 1931

replace contyrs = 12 if statefip == 36 & year >= 1931

** North Carolina
replace entryage = 7 if statefip == 37 & year >= 1931

replace exitage = 14 if statefip == 37 & year >= 1931 & year < 1945
replace exitage = 15 if statefip == 37 & year == 1945
replace exitage = 16 if statefip == 37 & year >= 1946

** North Dakota
replace entryage = 7 if statefip == 38 & year >= 1931

replace exitage = 17 if statefip == 38 & year >= 1931

replace earlyyrs = 8 if statefip == 38 & year >= 1931

replace earlyyrs_condition = 15 if statefip == 38 & year >= 1931

** Ohio
replace entryage = 6 if statefip == 39 & year >= 1931

replace exitage = 18 if statefip == 39 & year >= 1931

replace earlyyrs = 12 if statefip == 39 & year >= 1931

replace workage = 16 if statefip == 39 & year >= 1931

replace workyrs = 7 if statefip == 39 & year >= 1931

replace contage = 18 if statefip == 39 & year >= 1931

replace contyrs = 12 if statefip == 39 & year >= 1931

** Oklahoma
replace entryage = 8 if statefip == 40 & year >= 1931 & year < 1936
replace entryage = 7 if statefip == 40 & year >= 1936

replace exitage = 18 if statefip == 40 & year >= 1931

replace earlyyrs = 998 if statefip == 40 & year >= 1931

replace workage = 16 if statefip == 40 & year >= 1931

replace workyrs = 8 if statefip == 40 & year >= 1931

replace contage = 18 if statefip == 40 & year >= 1931

replace contyrs = 9910 if statefip == 40 & year >= 1931

** Oregon
replace entryage = 9 if statefip == 41 & year >= 1912 & year < 1926
replace entryage = 8 if statefip == 41 & year >= 1926 & year < 1946
replace entryage = 7 if statefip == 41 & year >= 1946

replace exitage = 15 if statefip == 41 & year >= 1912 & year < 1926
replace exitage = 16 if statefip == 41 & year >= 1926 & year < 1946
replace exitage = 18 if statefip == 41 & year >= 1946

replace earlyyrs = 8 if statefip == 41 & year >= 1931

replace earlyyrs_condition = 16 if statefip == 41 & year >= 1931

replace workage = 14 if statefip == 41 & year >= 1931

replace workyrs = 8 if statefip == 41 & year >= 1931

replace contage = 18 if statefip == 41 & year >= 1931

replace contyrs = 8 if statefip == 41 & year >= 1931

** Pennsylvania
replace entryage = 8 if statefip == 42 & year >= 1931

replace exitage = 16 if statefip == 42 & year >= 1931 & year < 1938
replace exitage = 17 if statefip == 42 & year == 1938
replace exitage = 18 if statefip == 42 & year >= 1939

replace workage = 14 if statefip == 42 & year >= 1931

replace workyrs = 6 if statefip == 42 & year >= 1931

replace contage = 16 if statefip == 42 & year >= 1931

** Rhode Island - no changes?
replace entryage = 7 if statefip == 44 & year >= 1931

replace exitage = 16 if statefip == 44 & year >= 1931

replace workage = 15 if statefip == 44 & year >= 1931

replace workyrs = 8 if statefip == 44 & year >= 1931

** South Carolina
replace entryage = 8 if statefip == 45 & year >= 1915 & year < 1937
replace entryage = 7 if statefip == 45 & year >= 1937

replace exitage = 16 if statefip == 45 & year >= 1915 & year < 1919
replace exitage = 14 if statefip == 45 & year >= 1919 & year < 1937
replace exitage = 16 if statefip == 45 & year >= 1937 

** South Dakota
replace entryage = 8 if statefip == 46 & year >= 1921 & year < 1941
replace entryage = 7 if statefip == 46 & year >= 1941

replace exitage = 16 if statefip == 46 & year >= 1915 & year < 1921
replace exitage = 17 if statefip == 46 & year >= 1921 & year < 1941
replace exitage = 16 if statefip == 46 & year >= 1941

** Tennessee
replace entryage = 7 if statefip == 47 & year >= 1919

replace exitage = 16 if statefip == 47 & year >= 1919

replace earlyyrs = 8 if statefip == 47 & year >= 1931

replace contage = 16 if statefip == 47 & year >= 1931

** Texas
replace entryage = 8 if statefip == 48 & year >= 1931 & year < 1935
replace entryage = 7 if statefip == 48 & year >= 1935

replace exitage = 14 if statefip == 48 & year >= 1931 & year < 1935
replace exitage = 16 if statefip == 48 & year >= 1935

** Utah - no changes?
replace entryage = 8 if statefip == 49 & year >= 1931

replace exitage = 18 if statefip == 49 & year >= 1931

replace earlyyrs = 12 if statefip == 49 & year >= 1931

replace workage = 14 if statefip == 49 & year >= 1931

replace workyrs = 8 if statefip == 49 & year >= 1931

replace contage = 18 if statefip == 49 & year >= 1931

replace contyrs = 12 if statefip == 49 & year >= 1931

** Vermont
replace entryage = 8 if statefip == 50 & year >= 1931 & year < 1945
replace entryage = 7 if statefip == 50 & year >= 1945

replace exitage = 16 if statefip == 50 & year >= 1931

replace earlyyrs = 8 if statefip == 50 & year >= 1931

** Virginia
replace entryage = 7 if statefip == 51 & year >= 1931 & year < 1934
replace entryage = 8 if statefip == 51 & year >= 1934

replace exitage = 15 if statefip == 51 & year >= 1931 & year < 1934
replace exitage = 16 if statefip == 51 & year >= 1934

replace workage = 14 if statefip == 51 & year >= 1931

replace workyrs = 997 if statefip == 51 & year >= 1931

** Washington
replace entryage = 8 if statefip == 53 & year >= 1931

replace exitage = 16 if statefip == 53 & year >= 1931

replace earlyyrs = 8 if statefip == 53 & year >= 1931

replace workage = 15 if statefip == 53 & year >= 1931

replace contage = 18 if statefip == 53 & year >= 1931

replace contyrs = 12 if statefip == 53 & year >= 1931

** West Virginia
replace entryage = 7 if statefip == 54 & year >= 1931

replace exitage = 16 if statefip == 54 & year >= 1931

replace earlyyrs = 8 if statefip == 54 & year >= 1931

replace workage = 14 if statefip == 54 & year >= 1931

replace workyrs = 6 if statefip == 54 & year >= 1931

replace contage = 16 if statefip == 54 & year >= 1931

replace contyrs = 8 if statefip == 54 & year >= 1931

** Wisconsin
replace entryage = 7 if statefip == 55 & year >= 1931

replace exitage = 16 if statefip == 55 & year >= 1931

replace earlyyrs = 8 if statefip == 55 & year >= 1931

replace workage = 14 if statefip == 55 & year >= 1931

replace workyrs = 8 if statefip == 55 & year >= 1931

replace contage = 18 if statefip == 55 & year >= 1931

replace contyrs = 12 if statefip == 55 & year >= 1931

** Wyoming
replace entryage = 7 if statefip == 56 & year >= 1931

replace exitage = 16 if statefip == 56 & year >= 1931

replace earlyyrs = 8 if statefip == 56 & year >= 1931

* save
save "D:\Datasets\US Census\jt_laws\state_age_limits_1850_1950_13may2025_JT.dta", replace
