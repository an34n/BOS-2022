Name:       c-505-12
Version:    1.0
Release:    1%{?dist}
Summary:    Программа студента Seden группы B20-505
Group:      Testing
License:    GPL
URL:        https://github.com/AXGORE/OSS-2022
Source:     %{name}-%{version}.tar.gz
BuildRequires: gcc

%global debug_package %{nil}

%description
A test package

%prep
%setup -q

%build
gcc -O2 -o c-505-12 c-505-12.c

%install
mkdir -p %{buildroot}%{_bindir}
cp c-505-12 %{buildroot}%{_bindir}
sudo rpm -i ~/rpmbuild/RPMS/noarch/505-12-1.0-1.fc38.noarch.rpm --force

%files
%{_bindir}/c-505-12

%changelog
* Thu Oct 16 2012 <Seden>
- Added %{_bindir}/c-505-12
