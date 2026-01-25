# 🩸 DAY 1 — LINUX ROOT HANDS-ON (WITH EXPLANATION)

> 🎯 **Goal:**
> Tum apni aankhon se dekho:

* process kaise banta hai
* CPU kaise share hota hai
* memory kaise jhooth bolti hai

---

## 🧪 LAB 0 — SYSTEM PEHCHAANO (5 min)

```bash
uname -a
```

🧠 **Explanation:**
Ye command kernel se poochti hai:

> “Tu kaun hai? Kaunsa version? Kaise build hua?”

---

```bash
lscpu
```

🧠 CPU ki physical reality:

* cores
* threads
* architecture

---

```bash
free -m
```

🧠 Memory ka **marketing vs reality**:

* `used` ≠ actually used
* `available` = real truth

✍️ **Likho:** kernel version, cores, RAM

---

## 🧪 LAB 1 — PROGRAM vs PROCESS (MOST IMPORTANT)

### Step 1: Program dekho (dead cheez)

```bash
ls -l /bin/sleep
```

🧠 Explanation:

* Ye sirf disk pe file hai
* CPU use nahi
* RAM use nahi

---

### Step 2: Process banao (zinda cheez)

```bash
sleep 300 &
```

```bash
echo $!
```

🧠 Explanation:

* `sleep` RAM me gaya
* PID mila
* Kernel ne entry process table me banayi

---

### Step 3: Process anatomy dekho

```bash
ps -o pid,ppid,stat,cmd -p <PID>
```

🧠 Explanation:

* PID → process ki identity
* PPID → parent (bash)
* STAT:

  * `S` = sleeping (waiting state)

---

## 🧪 LAB 2 — PROCESS TREE (RELATIONSHIP)

```bash
pstree -p
```

🧠 Explanation:

* Kernel har process ka parent maintain karta hai
* Orphan hone pe parent = PID 1 (systemd)

🎯 **ROOT REALITY:**
Production me orphan processes memory leak karte hain.

---

## 🧪 LAB 3 — CPU TORTURE (REALITY CHECK)

### Step 1: CPU khana start

```bash
yes > /dev/null &
yes > /dev/null &
```

🧠 Explanation:

* `yes` infinite loop
* CPU continuously instructions execute kar raha

---

### Step 2: Observe

```bash
top
```

Focus on:

* `%us` → user space CPU
* `%sy` → kernel space CPU
* `id` → idle

---

```bash
uptime
```

🧠 Explanation:

* Load average ≠ CPU usage
* Load = running + waiting processes

---

### Step 3: Cleanup

```bash
killall yes
```

🧠 Kernel ne context switch kam kar diya → system normal

---

## 🧪 LAB 4 — MEMORY TRUTH (JHOOTH PAKDO)

```bash
free -m
```

🧠 Explanation:

* Kernel RAM ko cache ke liye use karta hai
* Cache = future speed

---

### Pressure daalo

```bash
stress --vm 1 --vm-bytes 70% --vm-keep
```

🧠 Explanation:

* Artificial memory pressure
* Kernel forced to choose: cache drop ya swap

---

Observe:

```bash
vmstat 1
```

🧠 Fields:

* `si` = swap in
* `so` = swap out

---

Cleanup:

```bash
pkill stress
```

---

## 🧪 LAB 5 — /proc (KERNEL KI LIVE AANKH)

```bash
ls /proc
```

🧠 Explanation:

* Ye real files nahi
* Kernel runtime info expose karta hai

---

```bash
cat /proc/<PID>/status
```

🧠 Dekho:

* State
* Memory
* Threads

---

## 🧠 FINAL THINKING (VERY IMPORTANT)

✍️ Answer likho:

1. Program aur process ka difference tumne kaise dekha?
2. CPU free hone ke baad bhi load kyun high ho sakta hai?
3. Swap hone ka matlab system fail ho gaya?
4. `/proc` ko edit kyun nahi kar sakte?

---

-------------------------------------------------------------------------------------------------------------------------


```bash
controlplane ~ ➜  uname -a
Linux controlplane 5.15.0-1083-gcp #92~20.04.1-Ubuntu SMP Tue Apr 29 09:12:55 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux

controlplane ~ ➜  

controlplane ~ ➜  lscpu
Architecture:             x86_64
  CPU op-mode(s):         32-bit, 64-bit
  Address sizes:          46 bits physical, 48 bits virtual
  Byte Order:             Little Endian
CPU(s):                   16
  On-line CPU(s) list:    0-15
Vendor ID:                GenuineIntel
  Model name:             Intel(R) Xeon(R) CPU @ 2.80GHz
    CPU family:           6
    Model:                85
    Thread(s) per core:   2
    Core(s) per socket:   8
    Socket(s):            1
    Stepping:             7
    BogoMIPS:             5600.44
    Flags:                fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdp
                          e1gb rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid
                           sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single ssbd 
                          ibrs ibpb stibp ibrs_enhanced fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm avx512f avx512dq rdseed adx
                           smap clflushopt clwb avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves arat avx512_vnni md_clear arch_capabil
                          ities
Virtualization features:  
  Hypervisor vendor:      KVM
  Virtualization type:    full
Caches (sum of all):      
  L1d:                    256 KiB (8 instances)
  L1i:                    256 KiB (8 instances)
  L2:                     8 MiB (8 instances)
  L3:                     33 MiB (1 instance)
NUMA:                     
  NUMA node(s):           1
  NUMA node0 CPU(s):      0-15
Vulnerabilities:          
  Gather data sampling:   Not affected
  Itlb multihit:          Not affected
  L1tf:                   Not affected
  Mds:                    Not affected
  Meltdown:               Not affected
  Mmio stale data:        Vulnerable: Clear CPU buffers attempted, no microcode; SMT Host state unknown
  Reg file data sampling: Not affected
  Retbleed:               Mitigation; Enhanced IBRS
  Spec rstack overflow:   Not affected
  Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl and seccomp
  Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:             Mitigation; Enhanced / Automatic IBRS; IBPB conditional; RSB filling; PBRSB-eIBRS SW sequence; BHI SW loop, KVM SW loo
                          p
  Srbds:                  Not affected
  Tsx async abort:        Vulnerable: Clear CPU buffers attempted, no microcode; SMT Host state unknown

controlplane ~ ➜  

controlplane ~ ➜  free -m
               total        used        free      shared  buff/cache   available
Mem:           64295       13782        1049         246       49462       49549
Swap:              0           0           0

controlplane ~ ➜  

controlplane ~ ➜  
labtop  sleep    slogin   

controlplane ~ ➜  ls -l /bin/sl
slabtop  sleep    slogin   

controlplane ~ ➜  ls -l /bin/sleep 
-rwxr-xr-x 1 root root 35336 Feb  8  2024 /bin/sleep

controlplane ~ ➜  sleep 300 &
[1] 56915

controlplane ~ ✦ ➜  echo $!
56915

controlplane ~ ✦ ➜  ps -o pid,ppid,stat,cmd -p 56915
    PID    PPID STAT CMD
  56915   43401 S    sleep 300

controlplane ~ ✦ ✖ pstree -p
systemd(1)─┬─containerd(904)─┬─{containerd}(915)
           │                 ├─{containerd}(916)
           │                 ├─{containerd}(919)
           │                 ├─{containerd}(920)
           │                 ├─{containerd}(921)
           │                 ├─{containerd}(922)
           │                 ├─{containerd}(923)
           │                 ├─{containerd}(924)
           │                 ├─{containerd}(925)
           │                 ├─{containerd}(926)
           │                 ├─{containerd}(928)
           │                 ├─{containerd}(930)
           │                 ├─{containerd}(932)
           │                 ├─{containerd}(934)
           │                 ├─{containerd}(2100)
           │                 ├─{containerd}(2624)
           │                 ├─{containerd}(2639)
           │                 ├─{containerd}(2640)
           │                 ├─{containerd}(8116)
           │                 ├─{containerd}(8515)
           │                 ├─{containerd}(9081)
           │                 ├─{containerd}(10278)
           │                 ├─{containerd}(12292)
           │                 └─{containerd}(19987)
           ├─containerd-shim(2138)─┬─kube-scheduler(2731)─┬─{kube-scheduler}(2968)
           │                       │                      ├─{kube-scheduler}(2969)
           │                       │                      ├─{kube-scheduler}(2970)
           │                       │                      ├─{kube-scheduler}(2971)
           │                       │                      ├─{kube-scheduler}(2980)
           │                       │                      ├─{kube-scheduler}(2981)
           │                       │                      ├─{kube-scheduler}(2985)
           │                       │                      ├─{kube-scheduler}(2986)
           │                       │                      ├─{kube-scheduler}(2987)
           │                       │                      ├─{kube-scheduler}(2995)
           │                       │                      ├─{kube-scheduler}(2996)
           │                       │                      ├─{kube-scheduler}(2997)
           │                       │                      ├─{kube-scheduler}(3005)
           │                       │                      ├─{kube-scheduler}(3019)
           │                       │                      ├─{kube-scheduler}(3034)
           │                       │                      ├─{kube-scheduler}(3035)
           │                       │                      ├─{kube-scheduler}(11549)
           │                       │                      ├─{kube-scheduler}(11550)
           │                       │                      ├─{kube-scheduler}(11551)
           │                       │                      └─{kube-scheduler}(11552)
           │                       ├─pause(2305)
           │                       ├─{containerd-shim}(2148)
           │                       ├─{containerd-shim}(2149)
           │                       ├─{containerd-shim}(2150)
           │                       ├─{containerd-shim}(2151)
           │                       ├─{containerd-shim}(2157)
           │                       ├─{containerd-shim}(2159)
           │                       ├─{containerd-shim}(2161)
           │                       ├─{containerd-shim}(2162)
           │                       ├─{containerd-shim}(2165)
           │                       ├─{containerd-shim}(2167)
           │                       └─{containerd-shim}(20062)
           ├─containerd-shim(2153)─┬─kube-controller(2728)─┬─{kube-controller}(2998)
           │                       │                       ├─{kube-controller}(2999)
           │                       │                       ├─{kube-controller}(3000)
           │                       │                       ├─{kube-controller}(3001)
           │                       │                       ├─{kube-controller}(3002)
           │                       │                       ├─{kube-controller}(3003)
           │                       │                       ├─{kube-controller}(3006)
           │                       │                       ├─{kube-controller}(3007)
           │                       │                       ├─{kube-controller}(3008)
           │                       │                       ├─{kube-controller}(3009)
           │                       │                       ├─{kube-controller}(3010)
           │                       │                       ├─{kube-controller}(3011)
           │                       │                       ├─{kube-controller}(3013)
           │                       │                       ├─{kube-controller}(3012)
           │                       │                       ├─{kube-controller}(3014)
           │                       │                       └─{kube-controller}(3563)
           │                       ├─pause(2288)
           │                       ├─{containerd-shim}(2168)
           │                       ├─{containerd-shim}(2169)
           │                       ├─{containerd-shim}(2170)
           │                       ├─{containerd-shim}(2171)
           │                       ├─{containerd-shim}(2177)
           │                       ├─{containerd-shim}(2178)
           │                       ├─{containerd-shim}(2180)
           │                       ├─{containerd-shim}(2184)
           │                       ├─{containerd-shim}(2190)
           │                       ├─{containerd-shim}(2191)
           │                       └─{containerd-shim}(2192)
           ├─containerd-shim(2166)─┬─kube-apiserver(2719)─┬─{kube-apiserver}(2964)
           │                       │                      ├─{kube-apiserver}(2965)
           │                       │                      ├─{kube-apiserver}(2966)
           │                       │                      ├─{kube-apiserver}(2967)
           │                       │                      ├─{kube-apiserver}(2973)
           │                       │                      ├─{kube-apiserver}(2974)
           │                       │                      ├─{kube-apiserver}(2975)
           │                       │                      ├─{kube-apiserver}(2976)
           │                       │                      ├─{kube-apiserver}(2982)
           │                       │                      ├─{kube-apiserver}(2983)
           │                       │                      ├─{kube-apiserver}(2984)
           │                       │                      ├─{kube-apiserver}(3004)
           │                       │                      ├─{kube-apiserver}(3015)
           │                       │                      ├─{kube-apiserver}(3016)
           │                       │                      ├─{kube-apiserver}(3017)
           │                       │                      ├─{kube-apiserver}(3018)
           │                       │                      ├─{kube-apiserver}(3022)
           │                       │                      ├─{kube-apiserver}(3023)
           │                       │                      ├─{kube-apiserver}(3028)
           │                       │                      ├─{kube-apiserver}(3030)
           │                       │                      └─{kube-apiserver}(34134)
           │                       ├─pause(2289)
           │                       ├─{containerd-shim}(2173)
           │                       ├─{containerd-shim}(2174)
           │                       ├─{containerd-shim}(2175)
           │                       ├─{containerd-shim}(2176)
           │                       ├─{containerd-shim}(2179)
           │                       ├─{containerd-shim}(2181)
           │                       ├─{containerd-shim}(2183)
           │                       ├─{containerd-shim}(2182)
           │                       ├─{containerd-shim}(2189)
           │                       ├─{containerd-shim}(2551)
           │                       └─{containerd-shim}(2552)
           ├─containerd-shim(2172)─┬─etcd(2726)─┬─{etcd}(2960)
           │                       │            ├─{etcd}(2961)
           │                       │            ├─{etcd}(2962)
           │                       │            ├─{etcd}(2963)
           │                       │            ├─{etcd}(2972)
           │                       │            ├─{etcd}(2977)
           │                       │            ├─{etcd}(2978)
           │                       │            ├─{etcd}(2979)
           │                       │            ├─{etcd}(2988)
           │                       │            ├─{etcd}(3020)
           │                       │            ├─{etcd}(3021)
           │                       │            ├─{etcd}(3024)
           │                       │            ├─{etcd}(3025)
           │                       │            ├─{etcd}(3026)
           │                       │            ├─{etcd}(3027)
           │                       │            ├─{etcd}(3029)
           │                       │            ├─{etcd}(3031)
           │                       │            ├─{etcd}(3032)
           │                       │            ├─{etcd}(3033)
           │                       │            ├─{etcd}(10781)
           │                       │            └─{etcd}(11580)
           │                       ├─pause(2317)
           │                       ├─{containerd-shim}(2185)
           │                       ├─{containerd-shim}(2186)
           │                       ├─{containerd-shim}(2187)
           │                       ├─{containerd-shim}(2188)
           │                       ├─{containerd-shim}(2193)
           │                       ├─{containerd-shim}(2195)
           │                       ├─{containerd-shim}(2197)
           │                       ├─{containerd-shim}(2199)
           │                       ├─{containerd-shim}(2200)
           │                       ├─{containerd-shim}(2203)
           │                       └─{containerd-shim}(23902)
           ├─containerd-shim(3591)─┬─kube-proxy(3717)─┬─{kube-proxy}(3808)
           │                       │                  ├─{kube-proxy}(3809)
           │                       │                  ├─{kube-proxy}(3810)
           │                       │                  ├─{kube-proxy}(3811)
           │                       │                  ├─{kube-proxy}(3812)
           │                       │                  ├─{kube-proxy}(3830)
           │                       │                  ├─{kube-proxy}(3833)
           │                       │                  ├─{kube-proxy}(3834)
           │                       │                  ├─{kube-proxy}(3835)
           │                       │                  ├─{kube-proxy}(3836)
           │                       │                  ├─{kube-proxy}(3837)
           │                       │                  └─{kube-proxy}(8472)
           │                       ├─pause(3619)
           │                       ├─{containerd-shim}(3592)
           │                       ├─{containerd-shim}(3593)
           │                       ├─{containerd-shim}(3594)
           │                       ├─{containerd-shim}(3595)
           │                       ├─{containerd-shim}(3596)
           │                       ├─{containerd-shim}(3597)
           │                       ├─{containerd-shim}(3598)
           │                       ├─{containerd-shim}(3599)
           │                       ├─{containerd-shim}(3600)
           │                       ├─{containerd-shim}(3608)
           │                       └─{containerd-shim}(14251)
           ├─containerd-shim(3766)─┬─flanneld(4902)─┬─{flanneld}(4985)
           │                       │                ├─{flanneld}(4986)
           │                       │                ├─{flanneld}(4987)
           │                       │                ├─{flanneld}(4988)
           │                       │                ├─{flanneld}(4989)
           │                       │                ├─{flanneld}(4991)
           │                       │                ├─{flanneld}(4992)
           │                       │                ├─{flanneld}(4995)
           │                       │                ├─{flanneld}(4996)
           │                       │                ├─{flanneld}(5741)
           │                       │                ├─{flanneld}(5742)
           │                       │                ├─{flanneld}(5743)
           │                       │                ├─{flanneld}(5744)
           │                       │                ├─{flanneld}(9497)
           │                       │                ├─{flanneld}(9498)
           │                       │                ├─{flanneld}(10664)
           │                       │                ├─{flanneld}(11875)
           │                       │                ├─{flanneld}(16680)
           │                       │                ├─{flanneld}(17924)
           │                       │                └─{flanneld}(21717)
           │                       ├─pause(3797)
           │                       ├─runsvdir(4618)─┬─runsv(4715)───calico-node(4719)─┬─{calico-node}(4725)
           │                       │                │                                 ├─{calico-node}(4727)
           │                       │                │                                 ├─{calico-node}(4729)
           │                       │                │                                 ├─{calico-node}(4732)
           │                       │                │                                 ├─{calico-node}(4736)
           │                       │                │                                 ├─{calico-node}(4749)
           │                       │                │                                 ├─{calico-node}(4750)
           │                       │                │                                 ├─{calico-node}(4751)
           │                       │                │                                 ├─{calico-node}(4752)
           │                       │                │                                 ├─{calico-node}(4753)
           │                       │                │                                 ├─{calico-node}(4765)
           │                       │                │                                 ├─{calico-node}(4766)
           │                       │                │                                 ├─{calico-node}(4767)
           │                       │                │                                 ├─{calico-node}(4806)
           │                       │                │                                 ├─{calico-node}(4810)
           │                       │                │                                 ├─{calico-node}(4811)
           │                       │                │                                 ├─{calico-node}(4812)
           │                       │                │                                 ├─{calico-node}(7101)
           │                       │                │                                 ├─{calico-node}(7104)
           │                       │                │                                 ├─{calico-node}(9001)
           │                       │                │                                 └─{calico-node}(9002)
           │                       │                ├─runsv(4716)───calico-node(4721)─┬─{calico-node}(4724)
           │                       │                │                                 ├─{calico-node}(4726)
           │                       │                │                                 ├─{calico-node}(4728)
           │                       │                │                                 ├─{calico-node}(4730)
           │                       │                │                                 ├─{calico-node}(4735)
           │                       │                │                                 ├─{calico-node}(4754)
           │                       │                │                                 ├─{calico-node}(10724)
           │                       │                │                                 └─{calico-node}(10725)
           │                       │                ├─runsv(4717)───calico-node(4720)─┬─{calico-node}(4738)
           │                       │                │                                 ├─{calico-node}(4739)
           │                       │                │                                 ├─{calico-node}(4740)
           │                       │                │                                 ├─{calico-node}(4741)
           │                       │                │                                 ├─{calico-node}(4742)
           │                       │                │                                 ├─{calico-node}(4755)
           │                       │                │                                 ├─{calico-node}(4756)
           │                       │                │                                 ├─{calico-node}(4757)
           │                       │                │                                 ├─{calico-node}(4758)
           │                       │                │                                 └─{calico-node}(10726)
           │                       │                └─runsv(4718)───calico-node(4722)─┬─{calico-node}(4723)
           │                       │                                                  ├─{calico-node}(4731)
           │                       │                                                  ├─{calico-node}(4733)
           │                       │                                                  ├─{calico-node}(4734)
           │                       │                                                  ├─{calico-node}(4737)
           │                       │                                                  ├─{calico-node}(4743)
           │                       │                                                  ├─{calico-node}(4744)
           │                       │                                                  ├─{calico-node}(4745)
           │                       │                                                  ├─{calico-node}(4746)
           │                       │                                                  ├─{calico-node}(4747)
           │                       │                                                  └─{calico-node}(4748)
           │                       ├─{containerd-shim}(3767)
           │                       ├─{containerd-shim}(3768)
           │                       ├─{containerd-shim}(3769)
           │                       ├─{containerd-shim}(3770)
           │                       ├─{containerd-shim}(3771)
           │                       ├─{containerd-shim}(3772)
           │                       ├─{containerd-shim}(3773)
           │                       ├─{containerd-shim}(3774)
           │                       ├─{containerd-shim}(3775)
           │                       ├─{containerd-shim}(3782)
           │                       └─{containerd-shim}(3783)
           ├─containerd-shim(6491)─┬─kube-controller(8648)─┬─{kube-controller}(8782)
           │                       │                       ├─{kube-controller}(8783)
           │                       │                       ├─{kube-controller}(8784)
           │                       │                       ├─{kube-controller}(8785)
           │                       │                       ├─{kube-controller}(8786)
           │                       │                       ├─{kube-controller}(8787)
           │                       │                       ├─{kube-controller}(8788)
           │                       │                       ├─{kube-controller}(8789)
           │                       │                       ├─{kube-controller}(8790)
           │                       │                       ├─{kube-controller}(8835)
           │                       │                       ├─{kube-controller}(8836)
           │                       │                       ├─{kube-controller}(8837)
           │                       │                       ├─{kube-controller}(8838)
           │                       │                       └─{kube-controller}(10040)
           │                       ├─pause(6656)
           │                       ├─{containerd-shim}(6496)
           │                       ├─{containerd-shim}(6498)
           │                       ├─{containerd-shim}(6499)
           │                       ├─{containerd-shim}(6501)
           │                       ├─{containerd-shim}(6507)
           │                       ├─{containerd-shim}(6508)
           │                       ├─{containerd-shim}(6509)
           │                       ├─{containerd-shim}(6510)
           │                       ├─{containerd-shim}(6511)
           │                       ├─{containerd-shim}(7156)
           │                       └─{containerd-shim}(9044)
           ├─containerd-shim(6778)─┬─coredns(7785)─┬─{coredns}(8019)
           │                       │               ├─{coredns}(8020)
           │                       │               ├─{coredns}(8021)
           │                       │               ├─{coredns}(8022)
           │                       │               ├─{coredns}(8023)
           │                       │               ├─{coredns}(8025)
           │                       │               ├─{coredns}(8055)
           │                       │               ├─{coredns}(8062)
           │                       │               ├─{coredns}(8077)
           │                       │               ├─{coredns}(10242)
           │                       │               ├─{coredns}(10243)
           │                       │               ├─{coredns}(10244)
           │                       │               ├─{coredns}(10245)
           │                       │               └─{coredns}(10246)
           │                       ├─pause(6982)
           │                       ├─{containerd-shim}(6831)
           │                       ├─{containerd-shim}(6832)
           │                       ├─{containerd-shim}(6833)
           │                       ├─{containerd-shim}(6834)
           │                       ├─{containerd-shim}(6842)
           │                       ├─{containerd-shim}(6844)
           │                       ├─{containerd-shim}(6845)
           │                       ├─{containerd-shim}(6846)
           │                       ├─{containerd-shim}(6847)
           │                       └─{containerd-shim}(6848)
           ├─containerd-shim(6878)─┬─coredns(7775)─┬─{coredns}(7988)
           │                       │               ├─{coredns}(7989)
           │                       │               ├─{coredns}(7990)
           │                       │               ├─{coredns}(7991)
           │                       │               ├─{coredns}(7998)
           │                       │               ├─{coredns}(7999)
           │                       │               ├─{coredns}(8000)
           │                       │               ├─{coredns}(8007)
           │                       │               ├─{coredns}(8008)
           │                       │               ├─{coredns}(8009)
           │                       │               ├─{coredns}(8010)
           │                       │               ├─{coredns}(8011)
           │                       │               ├─{coredns}(8012)
           │                       │               ├─{coredns}(9894)
           │                       │               ├─{coredns}(9895)
           │                       │               ├─{coredns}(9896)
           │                       │               └─{coredns}(9897)
           │                       ├─pause(7076)
           │                       ├─{containerd-shim}(6882)
           │                       ├─{containerd-shim}(6883)
           │                       ├─{containerd-shim}(6884)
           │                       ├─{containerd-shim}(6885)
           │                       ├─{containerd-shim}(6922)
           │                       ├─{containerd-shim}(6923)
           │                       ├─{containerd-shim}(6924)
           │                       ├─{containerd-shim}(6925)
           │                       ├─{containerd-shim}(6926)
           │                       ├─{containerd-shim}(6973)
           │                       └─{containerd-shim}(42798)
           ├─dbus-daemon(830)
           ├─kubectl(3915)─┬─{kubectl}(3919)
           │               ├─{kubectl}(3921)
           │               ├─{kubectl}(3922)
           │               ├─{kubectl}(3923)
           │               ├─{kubectl}(3924)
           │               ├─{kubectl}(3938)
           │               ├─{kubectl}(3939)
           │               ├─{kubectl}(3954)
           │               └─{kubectl}(3955)
           ├─kubelet(3387)─┬─{kubelet}(3388)
           │               ├─{kubelet}(3389)
           │               ├─{kubelet}(3390)
           │               ├─{kubelet}(3391)
           │               ├─{kubelet}(3392)
           │               ├─{kubelet}(3399)
           │               ├─{kubelet}(3400)
           │               ├─{kubelet}(3401)
           │               ├─{kubelet}(3405)
           │               ├─{kubelet}(3406)
           │               ├─{kubelet}(3409)
           │               ├─{kubelet}(3410)
           │               ├─{kubelet}(3411)
           │               ├─{kubelet}(3419)
           │               ├─{kubelet}(3423)
           │               ├─{kubelet}(3472)
           │               ├─{kubelet}(3473)
           │               ├─{kubelet}(3474)
           │               ├─{kubelet}(3735)
           │               ├─{kubelet}(3736)
           │               ├─{kubelet}(4033)
           │               ├─{kubelet}(4564)
           │               └─{kubelet}(11700)
           ├─packagekitd(1263)─┬─{packagekitd}(1264)
           │                   └─{packagekitd}(1265)
           ├─polkitd(1273)─┬─{polkitd}(1274)
           │               └─{polkitd}(1276)
           ├─sshd(905)
           ├─start-ttyd.sh(903)───ttyd(908)─┬─script(43059)───sh(43061)───sudo(43062)───sudo(43063)───su(43064)───bash(43133)
           │                                ├─script(43393)───sh(43397)───sudo(43398)───sudo(43399)───su(43400)───bash(43401)─┬─pstree(60565)
           │                                │                                                                                 └─sleep(56915)
           │                                ├─{ttyd}(43060)
           │                                └─{ttyd}(43394)
           ├─systemd(43084)───(sd-pam)(43085)
           ├─systemd-journal(190)
           ├─systemd-logind(889)
           └─systemd-udevd(418)

controlplane ~ ✦ ➜ top
top - 06:35:02 up 0 min,  2 users,  load average: 5.53, 6.16, 5.14
Tasks:  66 total,   3 running,  63 sleeping,   0 stopped,   0 zombie
%Cpu(s): 13.1 us,  8.7 sy,  0.0 ni, 77.4 id,  0.0 wa,  0.0 hi,  0.8 si,  0.0 st
MiB Mem :  64295.2 total,   1069.6 free,  14547.6 used,  48678.1 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used.  48783.8 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                                  
  68079 root      20   0    6088   1116   1024 R 100.0   0.0   0:38.60 yes                                                                      
  68101 root      20   0    6088   1020    928 R 100.0   0.0   0:37.47 yes                                                                      
   2719 root      20   0 1583576 340416  70184 S  1600   0.5   3:49.14 kube-apiserver                                                           
  43084 root      20   0   17272   5516   3700 S 100.0   0.0   0:36.29 systemd                                                                  
      1 root      20   0  166712   9136   5304 S 100.0   0.0   1:21.57 systemd                                                                  
   2726 root      20   0   11.2g  70872  27128 S  1400   0.1   2:01.58 etcd

controlplane ~ ➜  free -m
               total        used        free      shared  buff/cache   available
Mem:           64295       14528        1073         247       48693       48803
Swap:              0           0           0

controlplane ~ ➜
controlplane ~ ✖ stress --vm 1 --vm-bytes 40G --vm-keep
stress: info: [73438] dispatching hogs: 0 cpu, 0 io, 1 vm, 0 hdd
stress: FAIL: [73438] (416) <-- worker 73439 got signal 9
stress: WARN: [73438] (418) now reaping child worker processes
stress: FAIL: [73438] (452) failed run completed in 14s

controlplane ~ ✖ pkill strees

controlplane ~ ➜  ls /proc
1     2305  3766   43085  4716  6778   903         consoles       filesystems  kmsg         mounts        softirqs       version
1263  2317  3797   43133  4717  6878   904         cpuinfo        fs           kpagecgroup  mtrr          stat           version_signature
1273  2719  3915   43393  4718  6982   905         crypto         interrupts   kpagecount   net           swaps          vmallocinfo
190   2726  418    43397  4719  7076   908         devices        iomem        kpageflags   pagetypeinfo  sys            vmstat
2138  2728  43059  43398  4720  7775   acpi        diskstats      ioports      loadavg      partitions    sysrq-trigger  zoneinfo
2153  2731  43061  43399  4721  7785   bootconfig  dma            irq          locks        pressure      sysvipc
2166  3387  43062  43400  4722  78127  buddyinfo   driver         kallsyms     mdstat       schedstat     thread-self
2172  3591  43063  43401  4902  830    bus         dynamic_debug  kcore        meminfo      scsi          timer_list
2288  3619  43064  4618   6491  8648   cgroups     execdomains    keys         misc         self          tty
2289  3717  43084  4715   6656  889    cmdline     fb             key-users    modules      slabinfo      uptime

controlplane ~ ➜  cat /proc/1/status
Name:   systemd
Umask:  0000
State:  S (sleeping)
Tgid:   1
Ngid:   0
Pid:    1
PPid:   0
TracerPid:      0
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 128
Groups: 0 
NStgid: 1
NSpid:  1
NSpgid: 1
NSsid:  1
VmPeak:   231964 kB
VmSize:   166712 kB
VmLck:         0 kB
VmPin:         0 kB
VmHWM:     12344 kB
VmRSS:      8784 kB
RssAnon:            3832 kB
RssFile:            4952 kB
RssShmem:              0 kB
VmData:    18928 kB
VmStk:      1036 kB
VmExe:       896 kB
VmLib:      9056 kB
VmPTE:       100 kB
VmSwap:        0 kB
HugetlbPages:          0 kB
CoreDumping:    0
THP_enabled:    1
Threads:        1
SigQ:   1/257146
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 7be3c0fe28014a03
SigIgn: 0000000000001000
SigCgt: 00000001000004ec
CapInh: 000001ffffffffff
CapPrm: 000001ffffffffff
CapEff: 000001ffffffffff
CapBnd: 000001ffffffffff
CapAmb: 000001ffffffffff
NoNewPrivs:     0
Seccomp:        2
Seccomp_filters:        1
Speculation_Store_Bypass:       thread force mitigated
SpeculationIndirectBranch:      conditional force disabled
Cpus_allowed:   ffff
Cpus_allowed_list:      0-15
Mems_allowed:   00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001
Mems_allowed_list:      0
voluntary_ctxt_switches:        2837027
nonvoluntary_ctxt_switches:     30092

controlplane ~ ➜  

controlplane ~ ➜              

```
