// イベントを発行している要素が、イベントが束縛されている要素でない場合は中止
if (event.target !== event.currentTarget) return
