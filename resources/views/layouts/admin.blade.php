<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Mamba'ul Ulum Admin</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>

:root{
    --primary:#0B5D35;
    --secondary:#16a34a;
    --light:#f8fafc;
    --dark:#1e293b;
}

body{
    margin:0;
    background:#f1f5f9;
    font-family:'Segoe UI',sans-serif;
}

/* SIDEBAR */
.sidebar{
    position:fixed;
    left:0;
    top:0;
    width:260px;
    height:100vh;
    background:linear-gradient(180deg,#0B5D35,#16a34a);
    color:white;
    z-index:1000;
    overflow-y:auto;
}

.sidebar-header{
    padding:25px;
    text-align:center;
    border-bottom:1px solid rgba(255,255,255,.2);
}

.sidebar-header h4{
    margin:0;
    font-weight:bold;
}

.sidebar-header small{
    opacity:.8;
}

.sidebar-menu{
    padding:15px;
}

.sidebar-menu a{
    display:flex;
    align-items:center;
    gap:12px;
    text-decoration:none;
    color:white;
    padding:14px 16px;
    border-radius:12px;
    margin-bottom:10px;
    transition:.3s;
}

.sidebar-menu a:hover{
    background:rgba(255,255,255,.15);
    transform:translateX(5px);
}

.sidebar-menu i{
    font-size:20px;
}

/* CONTENT */
.main-content{
    margin-left:260px;
    min-height:100vh;
    padding:25px;
}

/* HEADER */
.top-header{
    background:white;
    border-radius:20px;
    padding:20px 25px;
    box-shadow:0 5px 15px rgba(0,0,0,.05);
    margin-bottom:25px;
}

.header-profile{
    display:flex;
    align-items:center;
    justify-content:space-between;
}

.header-left h4{
    margin:0;
    font-weight:bold;
    color:var(--primary);
}

.header-left p{
    margin:0;
    color:#64748b;
}

.profile-img{
    width:55px;
    height:55px;
    border-radius:50%;
}

/* FOOTER */
.footer{
    margin-top:40px;
    text-align:center;
    color:#64748b;
    font-size:14px;
}

/* MOBILE */
@media(max-width:768px){
    .sidebar{
        width:80px;
    }

    .sidebar-header h4,
    .sidebar-header small,
    .sidebar-menu span{
        display:none;
    }

    .main-content{
        margin-left:80px;
    }

    .sidebar-menu a{
        justify-content:center;
    }
}

/* PROFILE BOX */
.profile-box{
    margin-top:10px;
    display:flex;
    flex-direction:column;
    gap:8px;
}

.profile-box a{
    text-decoration:none;
    font-size:14px;
    color:white;
    padding:8px 10px;
    border-radius:8px;
    background:rgba(255,255,255,.12);
    transition:.3s;
    display:flex;
    align-items:center;
    gap:8px;
}

.profile-box a:hover{
    background:rgba(255,255,255,.25);
}

/* JADWAL BUTTON */
.jadwal-btn{
    display:flex;
    align-items:center;
    justify-content:center;
    gap:8px;
    background:#facc15;
    color:#1e293b;
    padding:12px;
    border-radius:12px;
    text-decoration:none;
    font-weight:600;
    margin-bottom:10px;
    transition:.3s;
}

.jadwal-btn:hover{
    background:#fde047;
    transform:translateX(5px);
}

</style>

</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">

    <div class="sidebar-header">
        <h4>🕌 Mamba'ul Ulum</h4>
        <small>Admin Panel</small>
    </div>

    <div class="sidebar-menu">

        <a href="{{ route('dashboard') }}">
            <i class="bi bi-house-door-fill"></i>
            <span>Dashboard</span>
        </a>

        <a href="{{ route('jadwal_sholat') }}">
            <i class="bi bi-clock-history"></i>
            <span>Jadwal Sholat</span>
        </a>

        <a href="{{ route('absensi.index') }}">
            <i class="bi bi-calendar-check-fill"></i>
            <span>Absensi</span>
        </a>

        <a href="{{ route('modul.index') }}">
            <i class="bi bi-file-earmark-pdf-fill"></i>
            <span>Modul</span>
        </a>

        <a href="{{ route('hizib.index') }}">
            <i class="bi bi-book-fill"></i>
            <span>Hizib</span>
        </a>

        <a href="{{ route('barzanji.index') }}">
            <i class="bi bi-journal-richtext"></i>
            <span>Barzanji</span>
        </a>

        <a href="{{ route('kitab.index') }}">
            <i class="bi bi-book-half"></i>
            <span>Kitab</span>
        </a>

        <hr class="text-white">

        <!-- PROFIL FIX (SUDAH BENAR) -->
        <div class="profile-box">

            <a href="{{ route('profile.index') }}">
                <i class="bi bi-person-circle"></i>
                Lihat Profil
            </a>

        </div>

        <hr class="text-white">

        <form action="{{ route('logout') }}" method="POST">
            @csrf
            <button class="btn btn-danger w-100">
                <i class="bi bi-box-arrow-right"></i>
                Logout
            </button>
        </form>

    </div>

</div>

<!-- CONTENT -->
<div class="main-content">

    <!-- HEADER -->
    <div class="top-header">

        <div class="header-profile">

            <div class="header-left">

                <h4>
                    Assalamu'alaikum,
                    {{ Auth::user()->name }}
                </h4>

                <p>
                    Selamat datang di Sistem Informasi
                    Pondok Pesantren Mamba'ul Ulum
                </p>

                <small id="jam"></small>

            </div>

            <img
                src="https://ui-avatars.com/api/?name={{ Auth::user()->name }}&background=16a34a&color=fff"
                class="profile-img">

        </div>

    </div>

    <!-- CONTENT PAGE -->
    @yield('content')

    <!-- FOOTER -->
    <div class="footer">
        © {{ date('Y') }} Pondok Pesantren Mamba'ul Ulum
    </div>

</div>

<script>
function updateJam(){
    const now = new Date();
    document.getElementById('jam').innerHTML =
        now.toLocaleString('id-ID');
}
setInterval(updateJam,1000);
updateJam();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
