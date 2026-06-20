<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Login Admin - Mamba'ul Ulum</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(
        135deg,
        #065f46,
        #0b5d35,
        #22c55e
    );
    font-family:'Segoe UI',sans-serif;
}

/* CARD */

.login-card{
    width:100%;
    max-width:600px;
    background:rgba(255,255,255,.92);
    border-radius:35px;
    padding:40px;
    box-shadow:0 20px 50px rgba(0,0,0,.2);
}

/* LOGO */

.logo{
    width:120px;
    height:120px;
    object-fit:contain;
}

.title{
    color:#0b5d35;
    font-weight:700;
    margin-top:15px;
}

.subtitle{
    color:#777;
    margin-bottom:25px;
}

/* INPUT */

.input-group{
    margin-bottom:18px;
}

.input-group-text{
    background:white;
    border-right:none;
}

.form-control{
    height:52px;
    border-left:none;
}

.form-control:focus{
    box-shadow:none;
    border-color:#ced4da;
}

/* BUTTON */

.btn-login{
    width:100%;
    height:55px;
    border:none;
    border-radius:15px;
    background:#0b5d35;
    color:white;
    font-size:18px;
    font-weight:600;
    transition:.3s;
}

.btn-login:hover{
    background:#094d2c;
}

/* ALERT */

.alert{
    border-radius:15px;
}

.quote{
    text-align:center;
    color:#777;
    margin-top:25px;
    font-size:14px;
}

@media(max-width:768px){

.login-card{
    margin:20px;
    padding:25px;
}

.logo{
    width:90px;
    height:90px;
}

}

</style>
</head>
<body>

<div class="login-card">

    <div class="text-center">

        <img
            src="{{ asset('images/logo.png') }}"
            class="logo"
            alt="Logo">

        <h1 class="title">
            MAMBA'UL ULUM
        </h1>

        <p class="subtitle">
            Kelompok Muzakarah
        </p>

    </div>

    @if(session('error'))
        <div class="alert alert-danger">
            {{ session('error') }}
        </div>
    @endif

    <form action="{{ route('login.post') }}" method="POST">
        @csrf

        <div class="input-group">

            <span class="input-group-text">
                <i class="bi bi-envelope-fill"></i>
            </span>

            <input
                type="email"
                name="email"
                class="form-control"
                placeholder="Masukkan Email"
                required>

        </div>

        <div class="input-group">

            <span class="input-group-text">
                <i class="bi bi-lock-fill"></i>
            </span>

            <input
                type="password"
                name="password"
                id="password"
                class="form-control"
                placeholder="Masukkan Password"
                required>

            <button
                type="button"
                class="btn btn-outline-secondary"
                onclick="togglePassword()">

                <i class="bi bi-eye"></i>

            </button>

        </div>

        <button
            type="submit"
            class="btn-login">

            LOGIN

        </button>

    </form>

    <div class="quote">

        "Barang siapa menempuh jalan untuk mencari ilmu,
        maka Allah akan mudahkan baginya jalan menuju surga."

    </div>

</div>

<script>

function togglePassword(){

    let password =
        document.getElementById('password');

    if(password.type === 'password'){
        password.type = 'text';
    }else{
        password.type = 'password';
    }
}

</script>

</body>
</html>
