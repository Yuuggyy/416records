// 416 Records — Web Preview (from Flutter source)
const episodes=[
  {num:1,title:'Recrutement',desc:'40 candidats, parking de Kinshasa'},
  {num:2,title:'Direction Artistique',desc:'20 candidats, Chantier Naval'},
  {num:3,title:'Clash',desc:'12 candidats, duels en freestyle'},
  {num:4,title:'Club',desc:'6 candidats, Millionaire Club'},
  {num:5,title:'Finale Festival',desc:'3 finalistes, grand live'}
];
const exclusives=[
  {title:'Coulisses E1',icon:'🎬',locked:true},
  {title:'Interview artiste',icon:'🎤',locked:true},
  {title:'Rehearsal freestyle',icon:'🎵',locked:true}
];
let stats={preRoll:0,interstitial:0,rewarded:0,banner:0,earnings:0};
const ecpm={preRoll:5,interstitial:5,rewarded:15,banner:0.5};

function showPreRoll(epTitle){
  const overlay=document.createElement('div');
  overlay.className='ad-overlay';
  overlay.innerHTML='<div class="ad-modal"><div class="ad-count" id="adCount">10</div><div class="ad-content">🎬 Publicité Pre-roll</div><div class="ad-skip" id="adSkip" style="visibility:hidden">Passer ▶</div><div class="ad-info">'+epTitle+'</div></div>';
  document.body.appendChild(overlay);
  let count=10;
  const timer=setInterval(()=>{
    count--;
    document.getElementById('adCount').textContent=count;
    if(count<=0){clearInterval(timer);document.getElementById('adSkip').style.visibility='visible';}
  },1000);
  document.getElementById('adSkip').onclick=()=>{
    overlay.remove();stats.preRoll++;stats.earnings+=ecpm.preRoll/1000;updateStats();
    showEpisode(epTitle);
  };
}

function showInterstitial(action){
  const overlay=document.createElement('div');
  overlay.className='ad-overlay';
  overlay.innerHTML='<div class="ad-modal"><div class="ad-count" id="adCount2">5</div><div class="ad-content">📢 Publicité</div><div class="ad-skip" id="adSkip2" style="visibility:hidden">Continuer ▶</div></div>';
  document.body.appendChild(overlay);
  let count=5;const timer=setInterval(()=>{count--;document.getElementById('adCount2').textContent=count;if(count<=0){clearInterval(timer);document.getElementById('adSkip2').style.visibility='visible';}},1000);
  document.getElementById('adSkip2').onclick=()=>{overlay.remove();stats.interstitial++;stats.earnings+=ecpm.interstitial/1000;updateStats();if(action)action();};
}

function showRewarded(title,icon){
  const overlay=document.createElement('div');
  overlay.className='ad-overlay';
  overlay.innerHTML='<div class="ad-modal"><div class="ad-count" id="adCount3">30</div><div class="ad-content">🎁 Pub Reward — '+icon+' '+title+'</div><div class="ad-skip" id="adSkip3" style="visibility:hidden">Récupérer ma récompense ✅</div><div class="ad-info">Debloque: '+title+'</div></div>';
  document.body.appendChild(overlay);
  let count=30;const timer=setInterval(()=>{count--;document.getElementById('adCount3').textContent=count;if(count<=0){clearInterval(timer);document.getElementById('adSkip3').style.visibility='visible';}},1000);
  document.getElementById('adSkip3').onclick=()=>{overlay.remove();stats.rewarded++;stats.earnings+=ecpm.rewarded/1000;updateStats();showToast('Contenu débloqué !');};
}

function showEpisode(title){
  const overlay=document.createElement('div');
  overlay.className='ad-overlay';
  overlay.innerHTML='<div class="video-modal"><div class="video-header"><button onclick="this.closest(".ad-overlay").remove()" style="background:none;border:none;color:#fff;font-size:24px;cursor:pointer">✕</button></div><div style="text-align:center;padding:40px"><div style="font-size:48px;margin-bottom:16px">▶️</div><h2 style="color:#fff;font-size:20px;margin-bottom:8px">'+title+'</h2><p style="color:#aaa;font-size:14px">Lecture en cours...</p></div></div>';
  document.body.appendChild(overlay);
}

function showToast(msg){
  const t=document.createElement('div');
  t.className='toast';t.textContent=msg;
  document.body.appendChild(t);
  setTimeout(()=>t.remove(),3000);
}

function updateStats(){
  const total=stats.preRoll+stats.interstitial+stats.rewarded+stats.banner;
  if(total>0){
    document.getElementById('miniStats').style.display='block';
    document.getElementById('statPreRoll').textContent=(stats.preRoll*ecpm.preRoll/1000).toFixed(4)+'$';
    document.getElementById('statInterstitial').textContent=(stats.interstitial*ecpm.interstitial/1000).toFixed(4)+'$';
    document.getElementById('statRewarded').textContent=(stats.rewarded*ecpm.rewarded/1000).toFixed(4)+'$';
    document.getElementById('statTotal').textContent=stats.earnings.toFixed(4)+'$';
    document.getElementById('statImpressions').textContent=total;
  }
}

function closeBanner(){document.getElementById('adBanner').style.display='none';}
function showAdStats(){document.getElementById('statsModal').style.display='flex';}
function closeStats(){document.getElementById('statsModal').style.display='none';}

// Render
document.getElementById('episodeList').innerHTML=episodes.map(ep=>
  '<div class="ep-card" onclick="showPreRoll(\''+ep.title+'\')"><div class="ep-num">'+ep.num+'</div><div class="ep-info"><div class="ep-title">'+ep.title+'</div><div class="ep-desc">'+ep.desc+'</div></div><div class="ep-ads">🎬</div><div class="ep-play">▶</div></div>'
).join('');

document.getElementById('exclusiveList').innerHTML=exclusives.map(ex=>
  '<div class="ep-card" onclick="showRewarded(\''+ex.title+'\',\''+ex.icon+'\')"><div class="ep-num" style="background:#f0f0f0;color:#1a1a2e">'+ex.icon+'</div><div class="ep-info"><div class="ep-title">'+ex.title+'</div><div class="ep-desc">Contenu exclusif</div></div><div class="ep-ads">🔒</div><div class="ep-play">▶</div></div>'
).join('');
