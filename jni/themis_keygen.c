/*
 * Copyright (c) 2015 Cossack Labs Limited
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <jni.h>
#include <themis/secure_keygen.h>
#include <themis/themis_error.h>

/* Should be same as in AsymmetricKey.java */
#define KEYTYPE_EC 0
#define KEYTYPE_RSA 1

JNIEXPORT jobjectArray JNICALL Java_com_cossacklabs_themis_KeypairGenerator_generateKeys(JNIEnv* env,
                                                                                         jobject thiz,
                                                                                         jint key_type)
{
    UNUSED(thiz);

    size_t private_key_length = 0;
    size_t public_key_length = 0;

    jbyteArray private_key;
    jbyteArray public_key;

    jbyte* priv_buf;
    jbyte* pub_buf;

    jobjectArray keys;

    themis_status_t res;

    switch (key_type) {
    case KEYTYPE_EC:
        res = themis_gen_ec_key_pair(NULL, &private_key_length, NULL, &public_key_length);
        break;
    case KEYTYPE_RSA:
        res = themis_gen_rsa_key_pair(NULL, &private_key_length, NULL, &public_key_length);
        break;
    default:
        return NULL;
    }

    if (THEMIS_BUFFER_TOO_SMALL != res) {
        return NULL;
    }

    private_key = (*env)->NewByteArray(env, private_key_length);
    if (!private_key) {
        return NULL;
    }

    public_key = (*env)->NewByteArray(env, public_key_length);
    if (!public_key) {
        return NULL;
    }

    priv_buf = (*env)->GetByteArrayElements(env, private_key, NULL);
    if (!priv_buf) {
        return NULL;
    }

    pub_buf = (*env)->GetByteArrayElements(env, public_key, NULL);
    if (!pub_buf) {
        (*env)->ReleaseByteArrayElements(env, private_key, priv_buf, 0);
        return NULL;
    }

    switch (key_type) {
    case KEYTYPE_EC:
        res = themis_gen_ec_key_pair((uint8_t*)priv_buf,
                                     &private_key_length,
                                     (uint8_t*)pub_buf,
                                     &public_key_length);
        break;
    case KEYTYPE_RSA:
        res = themis_gen_rsa_key_pair((uint8_t*)priv_buf,
                                      &private_key_length,
                                      (uint8_t*)pub_buf,
                                      &public_key_length);
        break;
    default:
        (*env)->ReleaseByteArrayElements(env, public_key, pub_buf, 0);
        (*env)->ReleaseByteArrayElements(env, private_key, priv_buf, 0);
        return NULL;
    }

    (*env)->ReleaseByteArrayElements(env, public_key, pub_buf, 0);
    (*env)->ReleaseByteArrayElements(env, private_key, priv_buf, 0);

    if (THEMIS_SUCCESS != res) {
        return NULL;
    }

    keys = (*env)->NewObjectArray(env, 2, (*env)->GetObjectClass(env, private_key), NULL);
    if (!keys) {
        return NULL;
    }

    (*env)->SetObjectArrayElement(env, keys, 0, private_key);
    (*env)->SetObjectArrayElement(env, keys, 1, public_key);

    return keys;
}
