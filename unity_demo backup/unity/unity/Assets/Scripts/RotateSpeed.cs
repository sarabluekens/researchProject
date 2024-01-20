using System;
using System.Numerics;
using UnityEngine;
using UnityEngine.EventSystems;

public class RotateSpeed : MonoBehaviour, IEventSystemHandler
{
    [SerializeField]
    UnityEngine.Vector3 CustomRotateAmount;

    // Start is called before the first frame update
    void Start()
    {
        CustomRotateAmount = new UnityEngine.Vector3(0, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {
        gameObject.transform.Rotate(CustomRotateAmount * Time.deltaTime * 10);

        for (int i = 0; i < Input.touchCount; ++i)
        {
            if (Input.GetTouch(i).phase.Equals(TouchPhase.Began))
            {
                var hit = new RaycastHit();

                Ray ray = Camera.main.ScreenPointToRay(Input.GetTouch(i).position);

                if (Physics.Raycast(ray, out hit))
                {
                    // This method is used to send data to Flutter
                    //UnityMessageManager.Instance.SendMessageToFlutter("The cube feels touched.");
                }
            }
        }
    }

    // This method is called from Flutter
    public void SetRotationSpeed(String message)
    {
        float value = float.Parse(message);
        CustomRotateAmount = new UnityEngine.Vector3(10, value, value);
    }
}
