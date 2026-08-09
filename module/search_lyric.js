// 歌词搜索
const { appid, clientver } = require('../util');

module.exports = (params, useAxios) => {
  const dataMap = {
    album_audio_id: params?.album_audio_id || 0,
    appid,
    clientver,
    duration: params.duration || 0,
    hash: params?.hash || '',
    // The public API documents `keywords`, while KuGou's upstream endpoint
    // expects `keyword`. Accept both spellings so alternate clients and
    // deployments cannot silently produce an empty lyric result.
    keyword: params?.keywords || params?.keyword || '',
    lrctxt: 1,
    man: params.man ?? 'no',
  };

  return useAxios({
    baseURL: 'https://lyrics.kugou.com',
    url: '/v1/search',
    method: 'GET',
    params: dataMap,
    cookie: params?.cookie || {},
    encryptType: 'android',
    clearDefaultParams: true,
    notSign: true,
  });
};
